import 'package:flutter/material.dart';
import '../../../data/services/game_service.dart';
import '../../../data/services/game_hub_service.dart';
import '../../../data/models/game_models.dart';
import '../game/lobby_screen.dart';
import '../chat/chat_widget.dart';

class FriendsScreen extends StatefulWidget {
  final GameService gameService;
  final String userId;
  final String nickname;

  const FriendsScreen({
    super.key,
    required this.gameService,
    required this.userId,
    required this.nickname,
  });

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isLoading = true;
  List<Friend> friends = [];
  List<FriendRequest> requests = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
    _listenToFriendEvents();
  }

  void _listenToFriendEvents() {
    widget.gameService.friendEvents.listen((event) {
      if (event is FriendRequestReceivedEvent) {
        _loadRequests();
      } else if (event is FriendRequestRespondedEvent) {
        _loadData();
      }
    });
  }

  Future<void> _loadData() async {
    setState(() => isLoading = true);
    try {
      await Future.wait([_loadFriends(), _loadRequests()]);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _loadFriends() async {
    final result = await widget.gameService.getFriends(widget.userId);
    if (mounted) setState(() => friends = result);
  }

  Future<void> _loadRequests() async {
    final result = await widget.gameService.getPendingRequests(widget.userId);
    if (mounted) setState(() => requests = result);
  }

  Future<void> _respondToRequest(String requestId, bool accept) async {
    try {
      await widget.gameService.respondToFriendRequest(
        requestId,
        widget.userId,
        accept,
      );
      _loadData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(accept ? 'Solicitud aceptada' : 'Solicitud rechazada'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _removeFriend(String friendId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar amigo'),
        content: const Text('¿Estás seguro de que quieres eliminar este amigo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await widget.gameService.removeFriend(widget.userId, friendId);
        _loadFriends();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }

  void _openChat(Friend friend) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: ChatWidget(
          gameService: widget.gameService,
          currentUserId: widget.userId,
          otherUserId: friend.id,
          title: friend.nickname,
        ),
      ),
    );
  }

  void _inviteToGame(Friend friend) {
    // TODO: Implementar invitación a partida
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Invitar a partida'),
        content: Text('¿Quieres invitar a ${friend.nickname} a una partida?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              // Aquí iría la lógica de invitación
            },
            child: const Text('Invitar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Amigos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () => _showSearchDialog(),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              icon: const Icon(Icons.people),
              text: 'Amigos (${friends.length})',
            ),
            Tab(
              icon: const Icon(Icons.mail),
              text: 'Solicitudes (${requests.length})',
            ),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildFriendsList(),
                _buildRequestsList(),
              ],
            ),
    );
  }

  Widget _buildFriendsList() {
    if (friends.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.people_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'No tienes amigos aún',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () => _showSearchDialog(),
              icon: const Icon(Icons.person_add),
              label: const Text('Agregar amigos'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadFriends,
      child: ListView.builder(
        itemCount: friends.length,
        itemBuilder: (context, index) {
          final friend = friends[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: friend.isOnline ? Colors.green : Colors.grey,
              child: Text(friend.nickname[0].toUpperCase()),
            ),
            title: Text(friend.nickname),
            subtitle: Text(
              friend.isOnline ? 'En línea' : 'Desconectado',
              style: TextStyle(
                color: friend.isOnline ? Colors.green : Colors.grey,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.chat_bubble_outline),
                  onPressed: () => _openChat(friend),
                  tooltip: 'Chat',
                ),
                IconButton(
                  icon: const Icon(Icons.videogame_asset),
                  onPressed: () => _inviteToGame(friend),
                  tooltip: 'Invitar a jugar',
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => _removeFriend(friend.id),
                  tooltip: 'Eliminar amigo',
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRequestsList() {
    if (requests.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.mail_outline, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No tienes solicitudes pendientes',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadRequests,
      child: ListView.builder(
        itemCount: requests.length,
        itemBuilder: (context, index) {
          final request = requests[index];
          return ListTile(
            leading: CircleAvatar(
              child: Text(request.senderNickname[0].toUpperCase()),
            ),
            title: Text(request.senderNickname),
            subtitle: Text('Te envió una solicitud de amistad'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.check, color: Colors.green),
                  onPressed: () => _respondToRequest(request.id, true),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: () => _respondToRequest(request.id, false),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (_) => _SearchUserDialog(
        gameService: widget.gameService,
        userId: widget.userId,
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class _SearchUserDialog extends StatefulWidget {
  final GameService gameService;
  final String userId;

  const _SearchUserDialog({
    required this.gameService,
    required this.userId,
  });

  @override
  State<_SearchUserDialog> createState() => _SearchUserDialogState();
}

class _SearchUserDialogState extends State<_SearchUserDialog> {
  final _searchCtrl = TextEditingController();
  bool isSearching = false;
  List<UserSearchResult> results = [];

  Future<void> _search() async {
    final query = _searchCtrl.text.trim();
    if (query.length < 2) return;

    setState(() => isSearching = true);
    try {
      final users = await widget.gameService.searchUsers(widget.userId, query);
      if (mounted) setState(() => results = users);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => isSearching = false);
    }
  }

  Future<void> _sendRequest(String nickname) async {
    try {
      await widget.gameService.sendFriendRequest(widget.userId, nickname);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Solicitud enviada')),
        );
        _search();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Buscar amigos'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                labelText: 'Nickname',
                hintText: 'Escribe al menos 2 caracteres',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _search,
                ),
              ),
              onSubmitted: (_) => _search(),
            ),
            const SizedBox(height: 16),
            if (isSearching)
              const CircularProgressIndicator()
            else if (results.isNotEmpty)
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final user = results[index];
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(user.nickname[0].toUpperCase()),
                      ),
                      title: Text(user.nickname),
                      trailing: user.isFriend
                          ? const Chip(
                              label: Text('Amigo'),
                              backgroundColor: Colors.green,
                              labelStyle: TextStyle(color: Colors.white),
                            )
                          : user.hasPendingRequest
                              ? const Chip(label: Text('Pendiente'))
                              : IconButton(
                                  icon: const Icon(Icons.person_add),
                                  onPressed: () => _sendRequest(user.nickname),
                                ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cerrar'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }
}
