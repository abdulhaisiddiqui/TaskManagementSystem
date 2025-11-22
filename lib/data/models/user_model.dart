// data/models/user_model.dart
import 'package:cloud_firestore/cloud_firestore.dart'; // ← Yeh import bhool gaye the!

class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final String? photoURL;
  final DateTime createdAt;
  final Map<String, dynamic> notificationSettings;
  final Map<String, dynamic> stats;

  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    this.photoURL,
    required this.createdAt,
    required this.notificationSettings,
    required this.stats,
  });

  // Fixed copyWith
  UserModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoURL,
    DateTime? createdAt,
    Map<String, dynamic>? notificationSettings,
    Map<String, dynamic>? stats,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      createdAt: createdAt ?? this.createdAt,
      notificationSettings: notificationSettings ?? this.notificationSettings,
      stats: stats ?? this.stats,
    );
  }

  Map<String, dynamic> toMap() => {
    'email': email,
    'displayName': displayName,
    'photoURL': photoURL ?? '',
    'createdAt': createdAt,
    'notificationSettings': notificationSettings,
    'stats': stats,
  };

  factory UserModel.fromMap(String uid, Map<String, dynamic> map) {
    return UserModel(
      uid: uid,
      email: map['email'] ?? '',
      displayName: map['displayName'] ?? '',
      photoURL: map['photoURL'],
      createdAt: (map['createdAt'] as Timestamp).toDate(), // ← Fixed
      notificationSettings: Map<String, dynamic>.from(map['notificationSettings'] ?? {}),
      stats: Map<String, dynamic>.from(map['stats'] ?? {}),
    );
  }
}