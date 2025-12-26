import 'package:hive_flutter/hive_flutter.dart';
import 'package:kodo/src/models/chat_tile_model.dart';
import 'package:kodo/src/models/message_model.dart';
import 'package:kodo/src/models/user_model.dart';

import '../models/chat_info_model.dart';

class KodoStorageService {
  static final KodoStorageService _instance = KodoStorageService._internal();
  factory KodoStorageService() => _instance;
  KodoStorageService._internal();
  static KodoStorageService get instance => _instance;

  static const _chatInfoBox = 'chat_info';
  static const _chatTilesBox = 'chat_tiles';
  static const _messagesBox = 'messages';
  static const _usersBox = 'users';

  late final Box _chatInfo;
  late final Box _chatTiles;
  late final Box _messages;
  late final Box _users;

  Future<void> init() async {
    await Hive.initFlutter();
    _chatInfo = await Hive.openBox(_chatInfoBox);
    _chatTiles = await Hive.openBox(_chatTilesBox);
    _messages = await Hive.openBox(_messagesBox);
    _users = await Hive.openBox(_usersBox);
  }

  KodoUser? getUser(String uid) {
    final data = _users.get(uid);
    return data == null ? null : KodoUser.fromMap(data);
  }

  Future<void> cacheUser(KodoUser user) {
    return _users.put(user.id, user.toMap());
  }

  List<ChatTileModel> getChatTiles() {
    return _chatTiles.values.map((e) => ChatTileModel.fromMap(e)).toList()
      ..sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));
  }

  Future<void> cacheChatTiles(List<ChatTileModel> tiles) async {
    for (final tile in tiles) {
      await _chatTiles.put(tile.chatId, tile.toMap());
    }
  }

  ChatInfo? getChatInfo(String id) {
    final existing = _chatInfo.get(id);
    if (existing != null) {
      return ChatInfo.fromMap(existing);
    }
    return null;
  }

  Future<void> cacheChatInfo(List<ChatInfo> infos) async {
    for (final info in infos) {
      await _chatInfo.put(info.id, info.toMap());
    }
  }

  Future<void> updateChatInfo(
    String id, {
    bool? isLocked,
    bool? isArchived,
  }) async {
    // Get the existing info
    ChatInfo? info = getChatInfo(id);

    if (info != null) {
      info.isArchived = isArchived ?? info.isArchived;
      info.isLocked = isLocked ?? info.isLocked;
    } else {
      info = ChatInfo(
        id: id,
        isLocked: isLocked ?? false,
        isArchived: isArchived ?? false,
      );
    }

    await _chatInfo.put(id, info.toMap());
  }

  List<Message> getMessages(String chatId) {
    final data = _messages.get(chatId) as List<dynamic>?;
    if (data == null) return [];
    return data.map((e) => Message.fromMap(e)).toList();
  }

  Future<void> cacheMessages(String chatId, List<Message> messages) {
    return _messages.put(chatId, messages.map((e) => e.toMap()).toList());
  }

  Future<void> clearMessages(String chatId) {
    return _messages.delete(chatId);
  }

  Future<void> clear() async {
    try {
      await Future.wait([
        _chatTiles.clear(),
        _messages.clear(),
        _users.clear(),
      ]);
    } catch (e) {
      print("Error clearing out boxes: $e");
    }
  }
}
