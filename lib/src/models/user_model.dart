import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kodo/utils/helpers.dart';

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

  factory KodoUser.fromMap(Map map) {
    final data = Map<String, dynamic>.from(map);
    return KodoUser(
      id: data['id'],
      username: data['username'],
      displayName: data['displayName'],
      email: data['email'],
      photoUrl: data['photoUrl'],
      about: data['about'],
      isOnline: data['isOnline'],
      lastSeen: parseTimestamp(data['lastSeen']),
      createdAt: parseTimestamp(data['createdAt']),
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
      'lastSeen': lastSeen.toDate().toIso8601String(),
      'createdAt': createdAt.toDate().toIso8601String(),
    };
  }

  @override
  String toString() {
    return jsonEncode(toMap());
  }
}
