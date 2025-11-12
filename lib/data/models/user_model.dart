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

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL ?? '',
      'createdAt': createdAt,
      'notificationSettings': notificationSettings,
      'stats': stats,
    };
  }

  factory UserModel.fromMap(String uid, Map<String, dynamic> map) {
    return UserModel(
      uid: uid,
      email: map['email'] ?? '',
      displayName: map['displayName'] ?? '',
      photoURL: map['photoURL'],
      createdAt: (map['createdAt']).toDate(),
      notificationSettings: Map<String, dynamic>.from(map['notificationSettings'] ?? {}),
      stats: Map<String, dynamic>.from(map['stats'] ?? {}),
    );
  }
}
