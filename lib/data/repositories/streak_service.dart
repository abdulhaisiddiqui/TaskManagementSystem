// lib/core/services/streak_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class StreakService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Returns list of unlocked badge IDs (if any)
  static Future<List<String>> updateStreakAndBadges(String uid) async {
    final userRef = _firestore.collection('users').doc(uid);
    final now = DateTime.now();
    final todayStr = DateFormat('yyyy-MM-dd').format(now);

    try {
      // define outside transaction so we can return it after the transaction
      final List<String> unlockedBadgeIds = [];

      await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(userRef);
        if (!snapshot.exists) {
          print("User document not found!");
          return;
        }

        final data = snapshot.data()!;
        final stats = Map<String, dynamic>.from(data['stats'] ?? {});
        final badges = Map<String, dynamic>.from(data['badges'] ?? {});

        // Last active date
        final String? lastDateStr = stats['lastActiveDate'] as String?;
        final DateTime? lastActiveDate = lastDateStr != null ? DateTime.parse(lastDateStr) : null;

        int currentStreak = stats['currentStreak'] ?? 0;
        int longestStreak = stats['longestStreak'] ?? 0;

        // Streak Logic
        if (lastActiveDate == null || _daysBetween(lastActiveDate, now) > 1) {
          currentStreak = 1;
        } else if (_daysBetween(lastActiveDate, now) == 1) {
          currentStreak++;
        }

        if (currentStreak > longestStreak) {
          longestStreak = currentStreak;
        }

        // Badge unlock logic (populate the outer list)
        final badgeRules = {
          'first_task': (stats['totalTasksCompleted'] ?? 0) + 1 >= 1,
          'week_warrior': currentStreak >= 7,
          'month_master': currentStreak >= 30,
          'fire_50': currentStreak >= 50,
          'legend_100': currentStreak >= 100,
          'early_bird': now.hour < 9,
          'night_owl': now.hour >= 22,
        };

        badgeRules.forEach((badgeId, condition) {
          if (condition == true && (badges[badgeId] ?? false) != true) {
            unlockedBadgeIds.add(badgeId);
          }
        });

        // Update Firestore
        final updateData = <String, dynamic>{
          'stats.currentStreak': currentStreak,
          'stats.longestStreak': longestStreak,
          'stats.lastActiveDate': todayStr,
          // Only increment totalTasksCompleted here. `completedTasks` is
          // already updated by TaskRepository.updateTask to avoid double counting.
          'stats.totalTasksCompleted': FieldValue.increment(1),
        };

        for (var badgeId in unlockedBadgeIds) {
          updateData['badges.$badgeId'] = true;
        }

        transaction.update(userRef, updateData);
      });

      print("Streak & Badges updated successfully!");
      return unlockedBadgeIds;
    } catch (e) {
      print("Streak update failed: $e");
      return <String>[];
    }
  }

  static int _daysBetween(DateTime a, DateTime b) {
    return DateTime(b.year, b.month, b.day)
        .difference(DateTime(a.year, a.month, a.day))
        .inDays;
  }
}