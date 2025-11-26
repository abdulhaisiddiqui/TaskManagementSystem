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
      // Auth not ready / no user — show loader (login flow handled elsewhere)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 12),

            Consumer<ProfileViewModel>(builder: (context, vm, child) {
              return Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChangeNotifierProvider.value(
                          value: vm,
                          child: const EditProfileScreen(),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit, size: 30),
                ),
              );
            }),

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
                final totalTasks = stats['totalTasksCompleted'] ?? stats['completedTasks'] ?? 0;

                return Column(
                  children: [
                    StreakCard(currentStreak: currentStreak, longestStreak: longestStreak),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.primary.withOpacity(0.85)
                        ]),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Amazing!', style: TextStyle(color: Colors.white, fontSize: 18)),
                          const SizedBox(height: 5),
                          Text(
                            'You have completed\n$totalTasks task${totalTasks != 1 ? 's' : ''}!',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
                          ),
                          // const SizedBox(height: 16),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const CompletedTasksScreen()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Theme.of(context).colorScheme.primary,
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              ),
                              child: const Text('Details'),
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
              icon: Icons.emoji_events_outlined,
              title: 'Your Badges',
              isLogout: false,
              callback: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BadgesScreen())),
            ),

            BuildMenuItem(icon: Icons.person_outline, title: "Account information", isLogout: false),

            BuildMenuItem(
              icon: Icons.logout,
              title: 'Log out',
              isLogout: true,
              callback: () {
                AuthViewModel().logout(context);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
              },
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}