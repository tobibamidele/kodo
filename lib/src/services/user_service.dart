import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kodo/src/models/user_model.dart';
import 'package:kodo/src/services/auth_service.dart';

class KodoUserService {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  CollectionReference get _users => _db.collection('users');

  /// Create a user document after authentication
  Future<void> createUserIfNotExists({
    required String username,
    required String displayName,
    required String about,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      print("User is NULL");
      return;
    }

    final doc = await _users.doc(user.uid).get();
    print("User Doc exist: ${doc.exists}");

    if (!doc.exists) {
      try {
        await _users.doc(user.uid).set({
          'id': user.uid,
          'email': user.email,
          'username': username,
          'displayName': displayName,
          'photoUrl': user.photoURL,
          'about': about,
          'isOnline': true,
          'lastSeen': FieldValue.serverTimestamp(),
          'createdAt': FieldValue.serverTimestamp(),
        });
      } catch (e) {
        print("Firestore error: $e");
      }
    }
  }

  /// Returns a stream of user data
  Stream<DocumentSnapshot> getUserStream(String userId) {
    return _users.doc(userId).snapshots();
  }

  /// Presence handling
  Future<void> setOnline(bool isOnline) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _users.doc(user.uid).update({
      'isOnline': isOnline,
      'lastSeen': FieldValue.serverTimestamp(),
    });
  }

  /// Returns a user queried by id
  Future<KodoUser?> getUserById(String id) async {
    final query = await _users.where('id', isEqualTo: id).limit(1).get();

    if (query.docs.isEmpty) return null;

    return KodoUser.fromDoc(query.docs.first);
  }

  /// Returns user queried by username
  Future<KodoUser?> getUserByUsername(String username) async {
    final query = await _users
        .where('username', isEqualTo: username.toLowerCase().trim())
        .limit(1)
        .get();

    if (query.docs.isEmpty) return null;

    return KodoUser.fromDoc(query.docs.first);
  }

  /// Gets the current user info
  Future<KodoUser?> getCurrentUser() async {
    final uid = AuthService.currentUser?.uid;
    if (uid == null) return null;
    final query = await _users.where('id', isEqualTo: uid).limit(1).get();

    if (query.docs.isEmpty) return null;

    return KodoUser.fromDoc(query.docs.first);
  }
}
