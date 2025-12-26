import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kodo/src/models/chat_model.dart';
import 'package:kodo/src/models/chat_tile_model.dart';
import 'package:kodo/src/models/message_model.dart';
import 'package:kodo/src/models/user_model.dart';

import 'storage_service.dart';

class ChatService {
  static final ChatService _instance = ChatService._internal();
  factory ChatService() => _instance;
  ChatService._internal();
  static ChatService get instance => _instance;

  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;
  final _storageService = KodoStorageService.instance;

  CollectionReference get _chats => _db.collection('chats');

  Stream<List<ChatTileModel>> chatTilesStream() {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return _chats
        .where('participants', arrayContains: uid)
        // .where('lastMessage', isNotEqualTo: '')
        // .orderBy('lastMessage')
        .orderBy('lastMessageAt', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
          return Future.wait(snapshot.docs.map(_buildChatTile));
        });
  }

  Future<ChatModel> getOrCreateChat({
    required String myUid,
    required KodoUser otherUser,
  }) async {
    final query = await _chats
        .where('participants', arrayContains: myUid)
        .get();

    for (final doc in query.docs) {
      final participants = List<String>.from(doc['participants']);
      if (participants.contains(otherUser.id)) {
        return ChatModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }
    }

    final docRef = _chats.doc();

    final chat = ChatModel(
      id: docRef.id,
      participants: [myUid, otherUser.id],
      lastMessage: '',
      lastMessageSenderId: '',
      lastMessageAt: Timestamp.now(),
      unreadCount: {myUid: 0, otherUser.id: 0},
    );

    await docRef.set(chat.toMap());
    return chat;
  }

  /// Create a chat between two users
  Future<String> createChat(String otherUserId) async {
    final currentUserId = _auth.currentUser!.uid;

    final query = await _chats
        .where('participants', arrayContains: currentUserId)
        .get();

    for (final doc in query.docs) {
      final participants = List<String>.from(doc['participants']);
      if (participants.contains(otherUserId)) {
        return doc.id;
      }
    }

    final chatDoc = await _chats.add({
      'participants': [currentUserId, otherUserId],
      'lastMessage': '',
      'lastMessageSenderId': '',
      'lastMessageAt': FieldValue.serverTimestamp(),
    });

    return chatDoc.id;
  }

  /// Send message
  Future<void> sendMessage({
    required String chatId,
    required String receiverId,
    required MessageType type,
    String? content,
    String? mediaUrl,
  }) async {
    final senderId = _auth.currentUser!.uid;

    final messagesRef = _chats.doc(chatId).collection('messages').doc();

    final message = Message(
      id: messagesRef.id,
      chatId: chatId,
      senderId: senderId,
      receiverId: receiverId,
      type: type,
      content: content,
      mediaUrl: mediaUrl,
      isSeen: false,
      isDelivered: true,
      isForwarded: false,
      isEdited: false,
      reactions: {},
      createdAt: Timestamp.now(),
    );

    await messagesRef.set(message.toMap());

    await _chats.doc(chatId).update({
      'lastMessage': content ?? type.name,
      'lastMessageSenderId': senderId,
      'unreadCount.$receiverId': FieldValue.increment(1),
      'lastMessageAt': Timestamp.now(),
    });
  }

  /// Edit a message
  Future<void> editMessage({
    required String chatId,
    required String messageId,
    required String newText,
  }) async {
    final userId = _auth.currentUser!.uid;

    final messageRef = _chats.doc(chatId).collection('messages').doc(messageId);

    final snapshot = await messageRef.get();
    if (!snapshot.exists) return;

    final data = snapshot.data() as Map<String, dynamic>;

    if (data['senderId'] != userId) return;
    if (data['type'] != MessageType.text.name) return;

    await messageRef.update({
      'content': newText,
      'isEdited': true,
      'editedAt': Timestamp.now(),
    });
  }

  /// Stream user's chats
  Stream<QuerySnapshot> getUserChats() {
    final userId = _auth.currentUser!.uid;

    return _chats
        .where('participants', arrayContains: userId)
        .orderBy('lastMessageAt', descending: true)
        .snapshots();
  }

  Future<void> markChatRead({
    required String myUid,
    required String chatId,
  }) async {
    await _db.collection('chats').doc(chatId).update({'unreadCount.$myUid': 0});
  }

  /// Stream messages in a chat
  Stream<List<Message>> getMessages(String chatId) {
    return _chats
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(Message.fromDoc).toList());
  }

  /// Mark message as seen
  Future<void> markMessageSeen(
    String chatId,
    String messageId,
    String receiverId,
  ) async {
    await _chats.doc(chatId).collection('messages').doc(messageId).update({
      'isSeen': true,
    });

    await _chats.doc(chatId).update({'unreadCount.$receiverId': 0});
  }

  /// React to a message in a chat
  Future<void> reactToMessage({
    required String chatId,
    required String messageId,
    required String emoji,
  }) async {
    final userId = _auth.currentUser!.uid;

    final messageRef = _chats.doc(chatId).collection('messages').doc(messageId);

    await messageRef.update({
      'reactions.$emoji': FieldValue.arrayUnion([userId]),
    });
  }

  Future<void> removeReaction({
    required String chatId,
    required String messageId,
    required String emoji,
  }) async {
    final userId = _auth.currentUser!.uid;

    final messageRef = _chats.doc(chatId).collection('messages').doc(messageId);

    await messageRef.update({
      'reactions.$emoji': FieldValue.arrayRemove([userId]),
    });
  }

  /// Firebase cannot conditionally delete nested keys, so cleanup is on client side
  Future<void> cleanupEmptyReactions({
    required String chatId,
    required String messageId,
    required String emoji,
  }) async {
    final messageRef = _chats.doc(chatId).collection('messages').doc(messageId);

    final snapshot = await messageRef.get();
    if (!snapshot.exists) return;

    final data = snapshot.data() as Map<String, dynamic>;
    final reactions = Map<String, dynamic>.from(data['reactions'] ?? {});

    final users = List<String>.from(reactions[emoji] ?? []);
    if (users.isEmpty) {
      await messageRef.update({'reactions.$emoji': FieldValue.delete()});
    }
  }

  /// What the UI uses to react
  /// Called by `ChatService().toggleReaction(..., ..., emoji)`
  Future<void> toggleReaction({
    required String chatId,
    required String messageId,
    required String emoji,
  }) async {
    final userId = _auth.currentUser!.uid;
    final messageRef = _chats.doc(chatId).collection('messages').doc(messageId);

    final snapshot = await messageRef.get();
    if (!snapshot.exists) return;

    final data = snapshot.data() as Map<String, dynamic>;
    final reactions = Map<String, dynamic>.from(data['reactions'] ?? {});
    final users = List<String>.from(reactions[emoji] ?? []);

    if (users.contains(userId)) {
      await removeReaction(chatId: chatId, messageId: messageId, emoji: emoji);
    } else {
      await messageRef.update({
        'reactions.$emoji': FieldValue.arrayUnion([userId]),
      });
    }
  }

  Future<List<ChatTileModel>> fetchChatTilesOnce() async {
    final uid = _auth.currentUser!.uid;

    final snapshot = await _chats
        .where('participants', arrayContains: uid)
        .orderBy('lastMessageAt', descending: true)
        .get();

    return Future.wait(snapshot.docs.map(_buildChatTile));
  }

  Future<ChatTileModel> _buildChatTile(QueryDocumentSnapshot chatDoc) async {
    final currentUserId = _auth.currentUser!.uid;
    final data = chatDoc.data() as Map<String, dynamic>;

    final participants = List<String>.from(data['participants']);
    final otherUserId = participants.firstWhere((id) => id != currentUserId);

    // Fetch other user
    final userDoc = await _db.collection('users').doc(otherUserId).get();
    final otherUser = KodoUser.fromDoc(userDoc);

    final userData = userDoc.data();
    if (userData == null) {
      throw StateError('User $otherUserId does not exist');
    }

    final lastSenderId = data['lastMessageSenderId'];
    final lastMessage = data['lastMessage'] ?? '';

    final lastMessageText = lastSenderId == currentUserId
        ? 'You: $lastMessage'
        : lastMessage;

    return ChatTileModel(
      chatId: chatDoc.id,
      otherUser: otherUser,
      displayName: userData['displayName'] as String,
      photoUrl: userData['photoUrl'] as String?,
      lastMessageText: lastMessageText,
      lastMessageTime: (data['lastMessageAt'] as Timestamp).toDate(),
      unreadCount: (data['unreadCount']?[currentUserId] ?? 0) as int,
    );
  }

  Future<List<Message>> fetchRecentMessages({
    required String chatId,
    int limit = 30,
  }) async {
    final snapshot = await _chats
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .get();

    return snapshot.docs.map(Message.fromDoc).toList().reversed.toList();
  }

  Future<List<Message>> fetchMoreMessages({
    required String chatId,
    required Timestamp lastCreatedAt,
    int limit = 30,
  }) async {
    final snapshot = await _chats
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .startAfter([lastCreatedAt])
        .limit(limit)
        .get();

    return snapshot.docs.map(Message.fromDoc).toList().reversed.toList();
  }

  /// Checks if a chat is unlocked
  Future<bool> isChatLocked({required String id}) async {
    final chatInfo = _storageService.getChatInfo(id);
    return chatInfo?.isLocked ?? false;
  }

  /// Checks if a chat is locked
  Future<bool> isChatArchived({required String id}) async {
    final chatInfo = _storageService.getChatInfo(id);
    return chatInfo?.isArchived ?? false;
  }

  Future<void> _lockChat({required String id}) async {
    await _storageService.updateChatInfo(id, isLocked: true);
  }

  Future<void> _unlockChat({required String id}) async {
    await _storageService.updateChatInfo(id, isLocked: false);
  }

  Future<void> _archiveChat({required String id}) async {
    await _storageService.updateChatInfo(id, isArchived: true);
  }

  Future<void> _unarchiveChat({required String id}) async {
    await _storageService.updateChatInfo(id, isArchived: false);
  }

  /// Locks or unlocks the chat based on its current status.
  Future<void> toggleChatLock({required String id}) async {
    if (await isChatLocked(id: id)) {
      await _unlockChat(id: id);
    } else {
      await _lockChat(id: id);
    }
  }

  /// Archives or unarchives the chat based on its current status
  Future<void> toggleChatArchived({required String id}) async {
    if (await isChatArchived(id: id)) {
      await _unarchiveChat(id: id);
    } else {
      await _archiveChat(id: id);
    }
  }
}
