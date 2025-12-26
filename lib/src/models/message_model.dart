// Defines the type of message sent
// Could be any of the below
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kodo/utils/helpers.dart';

enum MessageType { text, image, video, audio, file }

// Class that holds the definition for the message model
class Message {
  /// message id
  final String id;

  /// Chat ID
  final String chatId;

  /// Sender ID
  final String senderId;

  /// Receiver ID
  final String receiverId;

  /// The type of message
  final MessageType type;

  /// Message content
  final String? content;

  /// URL for audiovisual messages on the firebase bucket
  final String? mediaUrl;

  /// Seen tag
  final bool isSeen;

  /// Delivered tag
  final bool isDelivered;

  /// Forwarded tag
  final bool? isForwarded;

  /// Edited tag
  final bool isEdited;

  /// Emoji => List of userIds
  final Map<String, List<String>> reactions;

  /// Timestamp of message creation
  final Timestamp createdAt;

  /// Timestamp of when message was edited
  final Timestamp? editedAt;

  Message({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.receiverId,
    required this.type,
    this.content,
    this.mediaUrl,
    required this.isSeen,
    required this.isDelivered,
    required this.isForwarded,
    required this.isEdited,
    required this.reactions,
    required this.createdAt,
    this.editedAt,
  });

  factory Message.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Message(
      id: doc.id,
      chatId: data['chatId'],
      senderId: data['senderId'],
      receiverId: data['receiverId'],
      type: MessageType.values.byName(data['type']),
      content: data['content'],
      mediaUrl: data['mediaUrl'],
      isSeen: data['isSeen'],
      isDelivered: data['isDelivered'],
      isForwarded: data['isForwarded'] ?? false,
      isEdited: data['isEdited'] ?? false,
      reactions: Map<String, List<String>>.from(
        (data['reactions'] ?? {}).map(
          (k, v) => MapEntry(k, List<String>.from(v)),
        ),
      ),
      createdAt: parseTimestamp(data['createdAt']),
      editedAt: data['editedAt'] != null
          ? parseTimestamp(data['editedAt'])
          : null,
    );
  }

  factory Message.fromMap(Map map) {
    final data = Map<String, dynamic>.from(map);
    return Message(
      id: data['id'],
      chatId: data['chatId'],
      senderId: data['senderId'],
      receiverId: data['receiverId'],
      type: MessageType.values.byName(data['type']),
      content: data['content'],
      mediaUrl: data['mediaUrl'],
      isSeen: data['isSeen'],
      isDelivered: data['isDelivered'],
      isForwarded: data['isForwarded'] ?? false,
      isEdited: data['isEdited'] ?? false,
      reactions: Map<String, List<String>>.from(
        (data['reactions'] ?? {}).map(
          (k, v) => MapEntry(k, List<String>.from(v)),
        ),
      ),
      createdAt: parseTimestamp(data['createdAt']),
      editedAt: data['editedAt'] != null
          ? parseTimestamp(data['editedAt'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'chatId': chatId,
      'senderId': senderId,
      'receiverId': receiverId,
      'type': type.name,
      'content': content,
      'mediaUrl': mediaUrl,
      'isSeen': isSeen,
      'isDelivered': isDelivered,
      'isForwarded': isForwarded,
      'isEdited': isEdited,
      'reactions': reactions,
      'createdAt': createdAt.toDate().toIso8601String(),
      'editedAt': editedAt?.toDate().toIso8601String(),
    };
  }
}
