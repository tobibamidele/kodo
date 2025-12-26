import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  /// Chat ID (Firestore document ID)
  final String id;

  /// All participants in this chat
  /// For 1–1 chat → exactly 2 IDs
  final List<String> participants;

  /// Last message preview (used in ChatList)
  final String lastMessage;

  /// Timestamp of the last message
  final Timestamp? lastMessageAt;

  final String? lastMessageSenderId;

  /// Per-user unread message count
  /// Example: { "uid1": 0, "uid2": 3 }
  final Map<String, int> unreadCount;

  ChatModel({
    required this.id,
    required this.participants,
    required this.lastMessage,
    required this.lastMessageAt,
    required this.lastMessageSenderId,
    required this.unreadCount,
  });

  factory ChatModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;

    return ChatModel(
      id: doc.id,
      participants: List<String>.from(data['participants'] ?? const []),
      lastMessage: data['lastMessage'] as String? ?? '',
      lastMessageAt: data['lastMessageAt'] as Timestamp?,
      lastMessageSenderId: data['lastMessageSenderId'] as String?,
      unreadCount: Map<String, int>.from(
        (data['unreadCounts'] as Map<String, dynamic>? ?? {}).map(
          (k, v) => MapEntry(k, (v as num).toInt()),
        ),
      ),
    );
  }

  factory ChatModel.fromDoc(String id, DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return ChatModel(
      id: id,
      participants: List<String>.from(data['participants']),
      lastMessage: data['lastMessage'] ?? '',
      lastMessageSenderId: data['lastMessageSenderId'] ?? '',
      lastMessageAt: data['lastMessageAt'],
      unreadCount: Map<String, int>.from(data['unreadCount'] ?? {}),
    );
  }

  // Firestore → Dart
  factory ChatModel.fromMap(String id, Map<String, dynamic> data) {
    return ChatModel(
      id: id,
      participants: List<String>.from(data['participants']),
      lastMessage: data['lastMessage'] ?? '',
      lastMessageSenderId: data['lastMessageSenderId'] ?? '',
      lastMessageAt: data['lastMessageAt'],
      unreadCount: Map<String, int>.from(data['unreadCount'] ?? {}),
    );
  }

  // Dart → Firestore
  Map<String, dynamic> toMap() {
    return {
      'participants': participants,
      'lastMessage': lastMessage,
      'lastMessageAt': lastMessageAt,
      'unreadCount': unreadCount,
    };
  }
}
