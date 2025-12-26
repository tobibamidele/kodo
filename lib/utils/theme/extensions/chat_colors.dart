import 'package:flutter/material.dart';

@immutable
class ChatColors extends ThemeExtension<ChatColors> {
  final Color myMessage;
  final Color otherMessage;

  const ChatColors({required this.myMessage, required this.otherMessage});

  @override
  ThemeExtension<ChatColors> copyWith({Color? myMessage, Color? otherMessage}) {
    return ChatColors(
      myMessage: myMessage ?? this.myMessage,
      otherMessage: otherMessage ?? this.otherMessage,
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
    );
  }
}
