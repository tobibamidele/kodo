import 'package:flutter/foundation.dart';
import 'package:kodo/src/models/message_model.dart';

@immutable
class ChatPageState {
  final List<Message> messages; // Messages
  final bool isSending; // Is message being sent
  final String? replyMessageId; // ID of the message the user is replying to
  final String? error; // Any error
  final bool isAtBottom; // Is the scroll offset at the bottom

  const ChatPageState({
    required this.messages,
    this.isSending = false,
    this.replyMessageId,
    this.error,
    this.isAtBottom = true,
  });

  ChatPageState copyWith({
    List<Message>? messages,
    bool? isSending,
    String? replyMessageId,
    String? error,
    bool? isAtBottom,
  }) {
    return ChatPageState(
      messages: messages ?? this.messages,
      replyMessageId:
          replyMessageId, // <== removed the this.replyMessageId because it wasn't setting the value to null in the [InputBar]
      isSending: isSending ?? this.isSending,
      error: error ?? this.error,
      isAtBottom: isAtBottom ?? this.isAtBottom,
    );
  }

  static const initial = ChatPageState(messages: []);
}
