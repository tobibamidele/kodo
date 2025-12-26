import 'package:kodo/src/models/user_model.dart';

class ChatTileModel {
  final String chatId;

  final KodoUser otherUser;
  final String displayName;
  final String? photoUrl;

  final String lastMessageText;
  final DateTime lastMessageTime;

  final int unreadCount;

  ChatTileModel({
    required this.chatId,
    required this.otherUser,
    required this.displayName,
    this.photoUrl,
    required this.lastMessageText,
    required this.lastMessageTime,
    required this.unreadCount,
  });

  factory ChatTileModel.fromMap(Map<String, dynamic> data) {
    return ChatTileModel(
      chatId: data['chatId'],
      otherUser: KodoUser.fromMap(data['otherUser']),
      displayName: data['displayName'],
      photoUrl: data['photoUrl'],
      lastMessageText: data['lastMessageText'],
      lastMessageTime: data['lastMessageTime'],
      unreadCount: data['unreadCount'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "chatId": chatId,
      "otherUser": otherUser.toMap(),
      "displayName": displayName,
      "photoUrl": photoUrl,
      "lastMessageText": lastMessageText,
      "lastMessageTime": lastMessageTime,
      "unreadCount": unreadCount,
    };
  }
}
