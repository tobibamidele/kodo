import 'dart:async';
import 'package:kodo/src/services/auth_service.dart';
import 'package:kodo/src/services/storage_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:kodo/src/state/chats/chat_page_state.dart';
import '../../models/chat_model.dart';
import '../../models/message_model.dart';
import '../../services/chat_service.dart';

part 'chat_page_controller.g.dart';

@riverpod
class ChatPageController extends _$ChatPageController {
  final ChatService _chatService = ChatService.instance;
  StreamSubscription<List<Message>>? _sub;

  @override
  Future<ChatPageState> build(ChatModel chat) async {
    // 1. Load cached messages first
    final storage = KodoStorageService.instance;
    final cachedMessages = storage.getMessages(chat.id);

    final initialState = ChatPageState(
      messages: cachedMessages,
      isSending: false,
    );

    // 2. Fetch fresh messages ONCE
    final fresh = await _chatService.fetchRecentMessages(chatId: chat.id);

    if (fresh.isNotEmpty) {
      await storage.cacheMessages(chat.id, fresh);
      state = AsyncData(initialState.copyWith(messages: fresh));
    } else {
      state = AsyncData(initialState);
    }

    // 3. Attach realtime stream ONLY after initial load
    _sub = _chatService.getMessages(chat.id).listen((messages) async {
      state = AsyncData(state.value!.copyWith(messages: messages));
      await storage.cacheMessages(chat.id, messages);
    });

    await _chatService.markChatRead(
      myUid: AuthService.currentUser!.uid,
      chatId: chat.id,
    );

    ref.onDispose(() {
      _sub?.cancel();
    });

    return initialState;
  }

  void setIsAtBottom(bool value) {
    state = AsyncData(state.value!.copyWith(isAtBottom: value));
  }

  void setReplyMessageId(String? messageId) {
    state = AsyncData(state.value!.copyWith(replyMessageId: messageId));
  }

  Stream<List<Message>> messagesStream() {
    return _chatService.getMessages(chat.id);
  }

  Future<void> sendText({
    required String receiverId,
    required String text,
    String? replyMessageId,
  }) async {
    if (text.trim().isEmpty) return;

    state = AsyncData(state.value!.copyWith(isSending: true));

    await _chatService.sendMessage(
      chatId: chat.id,
      receiverId: receiverId,
      type: MessageType.text,
      content: text,
      isReply: (replyMessageId != null),
      replyMessageId: replyMessageId,
    );

    state = AsyncData(state.value!.copyWith(isSending: false));
  }

  Future<void> editMessage({
    required String messageId,
    required String newText,
  }) {
    return _chatService.editMessage(
      chatId: chat.id,
      messageId: messageId,
      newText: newText,
    );
  }

  Future<void> toggleReaction({
    required String messageId,
    required String emoji,
  }) async {
    await _chatService.toggleReaction(
      chatId: chat.id,
      messageId: messageId,
      emoji: emoji,
    );

    await _chatService.cleanupEmptyReactions(
      chatId: chat.id,
      messageId: messageId,
      emoji: emoji,
    );
  }

  Future<void> loadMore() async {
    final messages = state.value!.messages;
    if (messages.isEmpty) return;

    final oldest = messages.first.createdAt;

    final more = await _chatService.fetchMoreMessages(
      chatId: chat.id,
      lastCreatedAt: oldest,
    );

    if (more.isEmpty) return;

    final updated = [...more, ...messages];
    state = AsyncData(state.value!.copyWith(messages: updated));

    await KodoStorageService().cacheMessages(chat.id, updated);
  }
}
