import 'package:flutter/foundation.dart';
import 'package:kodo/src/models/message_model.dart';

@immutable
class ChatPageState {
  final List<Message> messages; // Messages
  final bool isSending; // Is message being sent
  final String? error; // Any error
  final bool isAtBottom; // Is the scroll offset at the bottom

  const ChatPageState({
    required this.messages,
    this.isSending = false,
    this.error,
    this.isAtBottom = true,
  });

  ChatPageState copyWith({
    List<Message>? messages,
    bool? isSending,
    String? error,
    bool? isAtBottom,
  }) {
    return ChatPageState(
      messages: messages ?? this.messages,
      isSending: isSending ?? this.isSending,
      error: error ?? this.error,
      isAtBottom: isAtBottom ?? this.isAtBottom,
    );
  }

  static const initial = ChatPageState(messages: []);
}
