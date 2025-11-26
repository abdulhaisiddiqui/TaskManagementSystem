// lib/viewmodels/streak_viewmodel.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StreakViewModel extends ChangeNotifier {
  int _currentStreak = 0;
  int _longestStreak = 0;
  int _totalTasksCompleted = 0;
  Map<String, bool> _badges = {};

  int get currentStreak => _currentStreak;
  int get longestStreak => _longestStreak;
  int get totalTasksCompleted => _totalTasksCompleted;
  Map<String, bool> get badges => Map.unmodifiable(_badges);

  bool hasBadge(String badgeId) => _badges[badgeId] ?? false;

  StreakViewModel() {
    _listenToUserStats();
  }

  void _listenToUserStats() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots()
        .listen((snapshot) {
      if (!snapshot.exists) return;

      final data = snapshot.data()!;
      final stats = data['stats'] ?? {};
      final badgeData = data['badges'] ?? {};

      _currentStreak = stats['currentStreak'] ?? 0;
      _longestStreak = stats['longestStreak'] ?? 0;
      _totalTasksCompleted = stats['totalTasksCompleted'] ?? 0;
      _badges = Map<String, bool>.from(badgeData.map((k, v) => MapEntry(k.toString(), v == true)));

      notifyListeners();
    });
  }
}