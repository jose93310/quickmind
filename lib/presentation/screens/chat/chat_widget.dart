import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/services/game_service.dart';
import '../../../data/services/game_hub_service.dart';
import '../../../data/models/game_models.dart';
import '../../../core/constants/api_constants.dart';
import '../../../storage/emoji_storage.dart';

class ChatWidget extends StatefulWidget {
  final GameService gameService;
  final String currentUserId;
  final String? gameId;
  final String? otherUserId;
  final String title;
  final bool showReactions;

  const ChatWidget({
    super.key,
    required this.gameService,
    required this.currentUserId,
    this.gameId,
    this.otherUserId,
    required this.title,
    this.showReactions = false,
  });

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  final TextEditingController _messageCtrl = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<dynamic> _messages = [];
  bool isLoading = true;
  bool _showEmojiPanel = false;
  List<String> _recentEmojis = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _loadRecentEmojis();
    _listenToChatEvents();
  }

  void _listenToChatEvents() {
    widget.gameService.chatEvents.listen((event) {
      if (!mounted) return;
      if (event is GameMessageReceivedEvent && widget.gameId != null) {
        if (event.message.gameId == widget.gameId) {
          setState(() => _messages.add(event.message));
          _scrollToBottom();
        }
      } else if (event is ChatMessageReceivedEvent && widget.otherUserId != null) {
        if (event.message.senderId == widget.otherUserId ||
            event.message.receiverId == widget.otherUserId) {
          setState(() => _messages.add(event.message));
          _scrollToBottom();
        }
      }
    });
  }

  Future<void> _loadRecentEmojis() async {
    final emojis = await EmojiStorage.getRecentEmojis();
    if (mounted) setState(() => _recentEmojis = emojis);
  }

  Future<void> _loadMessages() async {
    try {
      if (widget.gameId != null) {
        final messages = await widget.gameService.getGameMessages(widget.gameId!);
        setState(() {
          _messages.clear();
          _messages.addAll(messages);
        });
      } else if (widget.otherUserId != null) {
        final messages = await widget.gameService.getConversation(
          widget.currentUserId,
          widget.otherUserId!,
        );
        setState(() {
          _messages.clear();
          _messages.addAll(messages);
        });
      }
    } catch (e) {
      // Silently fail
    } finally {
      if (mounted) setState(() => isLoading = false);
      _scrollToBottom();
    }
  }

  Future<void> _sendMessage() async {
    final text = _messageCtrl.text.trim();
    if (text.isEmpty) return;
    _messageCtrl.clear();

    try {
      if (widget.gameId != null) {
        await widget.gameService.sendGameMessage(
          widget.gameId!,
          widget.currentUserId,
          text,
        );
      } else if (widget.otherUserId != null) {
        await widget.gameService.sendChatMessage(
          widget.currentUserId,
          widget.otherUserId!,
          text,
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

  void _insertEmoji(String emoji) {
    final text = _messageCtrl.text;
    final selection = _messageCtrl.selection;
    final start = selection.start;
    final newText = text.replaceRange(start, selection.end, emoji);
    _messageCtrl.text = newText;
    _messageCtrl.selection = TextSelection.collapsed(
      offset: start + emoji.length,
    );
    EmojiStorage.addRecentEmoji(emoji);
    _loadRecentEmojis();
    setState(() => _showEmojiPanel = false);
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (image != null) {
        await _uploadMedia(image.path, 'image');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _uploadMedia(String filePath, String mediaType) async {
    try {
      final result = await widget.gameService.uploadMedia(filePath);
      final url = result['url'] as String;
      final type = result['mediaType'] as String;

      if (widget.gameId != null) {
        await widget.gameService.sendGameMessage(
          widget.gameId!,
          widget.currentUserId,
          '',
          mediaUrl: url,
          mediaType: type,
        );
      } else if (widget.otherUserId != null) {
        await widget.gameService.sendChatMessage(
          widget.currentUserId,
          widget.otherUserId!,
          '',
          mediaUrl: url,
          mediaType: type,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error subiendo archivo: $e')),
        );
      }
    }
  }

  void _sendReaction(String reaction) async {
    if (widget.gameId == null) return;
    try {
      await widget.gameService.sendGameReaction(
        widget.gameId!,
        widget.currentUserId,
        reaction,
      );
    } catch (e) {
      // Silently fail
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  bool _isMe(dynamic message) {
    if (message is GameMessage) return message.senderId == widget.currentUserId;
    if (message is ChatMessage) return message.senderId == widget.currentUserId;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Row(
            children: [
              const Icon(Icons.chat_bubble_outline, size: 20),
              const SizedBox(width: 8),
              Text(
                widget.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              if (widget.showReactions) _buildReactionsBar(),
            ],
          ),
        ),
        
        // Messages
        Expanded(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : _messages.isEmpty
                  ? const Center(
                      child: Text(
                        'No hay mensajes aún',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(8),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        return _buildMessageBubble(message);
                      },
                    ),
        ),
        
        // Emoji panel
        if (_showEmojiPanel) _buildEmojiPanel(),
        
        // Input
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border(
              top: BorderSide(
                color: Theme.of(context).dividerColor,
              ),
            ),
          ),
          child: SafeArea(
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    _showEmojiPanel ? Icons.keyboard : Icons.emoji_emotions_outlined,
                    color: _showEmojiPanel 
                        ? Theme.of(context).colorScheme.primary 
                        : null,
                  ),
                  onPressed: () {
                    setState(() => _showEmojiPanel = !_showEmojiPanel);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.image),
                  onPressed: _pickImage,
                ),
                Expanded(
                  child: TextField(
                    controller: _messageCtrl,
                    decoration: const InputDecoration(
                      hintText: 'Escribe un mensaje...',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    ),
                    onTap: () {
                      if (_showEmojiPanel) {
                        setState(() => _showEmojiPanel = false);
                      }
                    },
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmojiPanel() {
    return Container(
      height: 280,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: Column(
        children: [
          // Recent emojis
          if (_recentEmojis.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              alignment: Alignment.centerLeft,
              child: Text(
                'Recientes',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemCount: _recentEmojis.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _insertEmoji(_recentEmojis[index]),
                    child: Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      child: Text(
                        _recentEmojis[index],
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  );
                },
              ),
            ),
            const Divider(height: 1),
          ],
          
          // Common emojis grid
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            alignment: Alignment.centerLeft,
            child: Text(
              'Emojis',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8,
                childAspectRatio: 1,
              ),
              itemCount: EmojiStorage.commonEmojis.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _insertEmoji(EmojiStorage.commonEmojis[index]),
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      EmojiStorage.commonEmojis[index],
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReactionsBar() {
    const reactions = ['🔥', '👍', '😂', '😱', '👏', '💀'];
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: reactions.map((r) => 
        InkWell(
          onTap: () => _sendReaction(r),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(r, style: const TextStyle(fontSize: 20)),
          ),
        ),
      ).toList(),
    );
  }

  Widget _buildMessageBubble(dynamic message) {
    final isMe = _isMe(message);
    final senderName = message is GameMessage 
        ? message.senderNickname 
        : (message as ChatMessage).senderNickname;
    final text = message is GameMessage 
        ? message.text 
        : (message as ChatMessage).text;
    final mediaUrl = message is GameMessage 
        ? message.mediaUrl 
        : (message as ChatMessage).mediaUrl;
    final mediaType = message is GameMessage 
        ? message.mediaType 
        : (message as ChatMessage).mediaType;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe 
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.2)
              : Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMe)
              Text(
                senderName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            if (text != null && text.isNotEmpty)
              Text(
                text,
                style: TextStyle(
                  fontSize: _isEmojiOnly(text) ? 32 : 16,
                ),
              ),
            if (mediaUrl != null)
              _buildMedia(mediaUrl, mediaType),
          ],
        ),
      ),
    );
  }

  bool _isEmojiOnly(String text) {
    final emojiRegex = RegExp(
      r'^[\p{Emoji}\p{Emoji_Modifier}\p{Emoji_Component}\p{Emoji_Modifier_Base}\p{Emoji_Presentation}\s]+$',
      unicode: true,
    );
    return emojiRegex.hasMatch(text) && text.length <= 8;
  }

  Widget _buildMedia(String url, String? type) {
    final fullUrl = url.startsWith('http') ? url : '${ApiConstants.serverUrl}$url';
    
    if (type == 'image') {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          fullUrl,
          height: 150,
          width: double.infinity,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return const SizedBox(
              height: 150,
              child: Center(child: CircularProgressIndicator()),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return const SizedBox(
              height: 100,
              child: Center(child: Icon(Icons.error)),
            );
          },
        ),
      );
    } else if (type == 'video') {
      return Container(
        height: 150,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Icon(Icons.play_circle_outline, color: Colors.white, size: 48),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  @override
  void dispose() {
    _messageCtrl.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
