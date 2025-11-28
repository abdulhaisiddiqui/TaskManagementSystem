// views/screens/profile/profile_screen.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/widgets/profilewidgets/build_Menu_Item.dart';
import '../../../core/utils/widgets/profilewidgets/profile_header.dart';
import '../../../core/utils/widgets/streak_card.dart';
import '../../../viewmodels/auth_viewmodel.dart';
import '../../../viewmodels/profile_viewmodel.dart';
import '../badge_screen.dart';
import '../editprofile/edit_profile_screen.dart';
import '../loginsignup/login_screen.dart';
import 'completed_task_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserStream(String uid) {
    return FirebaseFirestore.instance.collection('users').doc(uid).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {

      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 12),

            Consumer<ProfileViewModel>(
              builder: (context, vm, child) => Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChangeNotifierProvider.value(
                          value: vm,
                          child: const EditProfileScreen(),
                        ),
                      ),
                    ),
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(Icons.edit, color: Theme.of(context).colorScheme.primary, size: 26),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),
            const ProfileHeader(),
            const SizedBox(height: 12),

            // Streak Card + Completed Tasks
            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: getUserStream(uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Text('No data found');
                }

                final data = snapshot.data!.data()!;
                final stats = Map<String, dynamic>.from(data['stats'] ?? {});

                final currentStreak = stats['currentStreak'] ?? 0;
                final longestStreak = stats['longestStreak'] ?? 0;
                final totalTasks =
                    stats['totalTasksCompleted'] ??
                    stats['completedTasks'] ??
                    0;

                return Column(
                  children: [
                    StreakCard(
                      currentStreak: currentStreak,
                      longestStreak: longestStreak,
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).colorScheme.primary,
                            Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.85),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Amazing work!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'You’ve completed\n$totalTasks task${totalTasks != 1 ? 's' : ''} so far!',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton.icon(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const CompletedTasksScreen(),
                                ),
                              ),
                              icon: const Icon(Icons.arrow_forward, size: 18),
                              label: const Text('View All'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Theme.of(
                                  context,
                                ).colorScheme.primary,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 12),

            BuildMenuItem(
              icon: Icons.emoji_events,
              title: 'Your Badges',
              isLogout: false,
              callback: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BadgesScreen()),
              ),
            ),

            BuildMenuItem(
              icon: Icons.person_outline,
              title: "Account information",
              isLogout: false,
            ),
            BuildMenuItem(
              icon: Icons.logout,
              title: 'Log out',
              isLogout: true,
              callback: () {
                AuthViewModel().logout(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
