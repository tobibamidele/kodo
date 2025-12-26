import 'package:cloud_firestore/cloud_firestore.dart';

class KodoUser {
  final String id;
  final String username;
  final String displayName;
  final String email;
  final String? photoUrl;
  final String? about;
  final bool isOnline;
  final Timestamp lastSeen;
  final Timestamp createdAt;

  KodoUser({
    required this.id,
    required this.username,
    required this.displayName,
    required this.email,
    this.photoUrl,
    this.about,
    required this.isOnline,
    required this.lastSeen,
    required this.createdAt,
  });

  factory KodoUser.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return KodoUser(
      id: data['id'],
      username: data['username'],
      displayName: data['displayName'],
      email: data['email'],
      photoUrl: data['photoUrl'],
      about: data['about'],
      isOnline: data['isOnline'],
      lastSeen: data['lastSeen'],
      createdAt: data['createdAt'],
    );
  }

  factory KodoUser.fromMap(Map<String, dynamic> data) {
    return KodoUser(
      id: data['id'],
      username: data['username'],
      displayName: data['displayName'],
      email: data['email'],
      photoUrl: data['photoUrl'],
      about: data['about'],
      isOnline: data['isOnline'],
      lastSeen: data['lastSeen'],
      createdAt: data['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'displayName': displayName,
      'email': email,
      'photoUrl': photoUrl,
      'about': about,
      'isOnline': isOnline,
      'lastSeen': lastSeen,
      'createdAt': createdAt,
    };
  }
}
