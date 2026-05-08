import 'package:shared_preferences/shared_preferences.dart';

class EmojiStorage {
  static const _keyRecent = 'recent_emojis';
  static const _keyUsageCount = 'emoji_usage_count';
  static const int maxRecent = 20;

  static final List<String> commonEmojis = [
    '😀', '😂', '🤣', '😊', '😍', '🥰', '😘', '😎',
    '🤔', '😅', '😢', '😭', '😡', '🥺', '😴', '🤮',
    '👍', '👎', '👏', '🙌', '🤝', '💪', '🎉', '🔥',
    '❤️', '💔', '💯', '⭐', '🎮', '🏆', '🥇', '🎯',
    '👀', '🧠', '💀', '👻', '🤡', '👽', '🤖', '🎃',
    '⚽', '🏀', '🏈', '🎯', '🎲', '🎰', '🃏', '🎭',
  ];

  static Future<List<String>> getRecentEmojis() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keyRecent) ?? [];
  }

  static Future<void> addRecentEmoji(String emoji) async {
    final prefs = await SharedPreferences.getInstance();
    final recent = prefs.getStringList(_keyRecent) ?? [];
    recent.remove(emoji);
    recent.insert(0, emoji);
    if (recent.length > maxRecent) {
      recent.removeRange(maxRecent, recent.length);
    }
    await prefs.setStringList(_keyRecent, recent);
  }
}
