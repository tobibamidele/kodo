import 'package:flutter/material.dart';

@immutable
class ChatColors extends ThemeExtension<ChatColors> {
  final Color myMessage;
  final Color otherMessage;
  final Color myReplyMessage;
  final Color otherReplyMessage;

  const ChatColors({
    required this.myMessage,
    required this.otherMessage,
    required this.myReplyMessage,
    required this.otherReplyMessage,
  });

  @override
  ThemeExtension<ChatColors> copyWith({
    Color? myMessage,
    Color? otherMessage,
    Color? myReplyMessage,
    Color? otherReplyMessage,
  }) {
    return ChatColors(
      myMessage: myMessage ?? this.myMessage,
      otherMessage: otherMessage ?? this.otherMessage,
      myReplyMessage: myReplyMessage ?? this.myReplyMessage,
      otherReplyMessage: otherReplyMessage ?? this.otherReplyMessage,
    );
  }

  @override
  ThemeExtension<ChatColors> lerp(
    covariant ThemeExtension<ChatColors>? other,
    double t,
  ) {
    if (other is! ChatColors) return this;
    return ChatColors(
      myMessage: Color.lerp(myMessage, other.myMessage, t)!,
      otherMessage: Color.lerp(otherMessage, other.otherMessage, t)!,
      myReplyMessage: Color.lerp(myReplyMessage, other.myReplyMessage, t)!,
      otherReplyMessage: Color.lerp(
        otherReplyMessage,
        other.otherReplyMessage,
        t,
      )!,
    );
  }
}
