import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taskapp/core/theme/app_color.dart';

class BadgesScreen extends StatelessWidget {
  const BadgesScreen({super.key});

  final List<Map<String, dynamic>> allBadges = const [
    {
      "id": "first_task",
      "name": "First Step",
      "image": "assets/badges/first-step.png",
      "desc": "Completed your first task",
      "gradient": [Color(0xFFFF9A9E), Color(0xFFFAD0C4)],
      "shadow": Color(0xFFFF9A9E),
    },
    {
      "id": "week_warrior",
      "name": "Week Warrior",
      "image": "assets/badges/week_warrior.png",
      "desc": "7 day streak",
      "gradient": [Color(0xFF6EE2F5), Color(0xFF6454F0)],
      "shadow": Color(0xFF6EE2F5),
    },
    {
      "id": "month_master",
      "name": "Month Master",
      "image": "assets/badges/month_master.png",
      "desc": "30 day streak",
      "gradient": [Color(0xFFFFD700), Color(0xFFFF8C00)],
      "shadow": Color(0xFFFFD700),
    },
    {
      "id": "fire_50",
      "name": "On Fire!",
      "image": "assets/badges/fire_50.png",
      "desc": "50 day streak",
      "gradient": [Color(0xFFFF416C), Color(0xFFFF4B2B)],
      "shadow": Color(0xFFFF416C),
    },
    {
      "id": "legend_100",
      "name": "Legend",
      "image": "assets/badges/legend_100.png",
      "desc": "100 day streak!",
      "gradient": [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
      "shadow": Color(0xFF8E2DE2),
    },
    {
      "id": "early_bird",
      "name": "Early Bird",
      "image": "assets/badges/early_bird.png",
      "desc": "Task before 9 AM",
      "gradient": [Color(0xFFFFD89B), Color(0xFF19547B)],
      "shadow": Color(0xFFFFD89B),
    },
    {
      "id": "night_owl",
      "name": "Night Owl",
      "image": "assets/badges/night_owl.png",
      "desc": "Task after 10 PM",
      "gradient": [Color(0xFF232526), Color(0xFF414345)],
      "shadow": Color(0xFF232526),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: AppColors.appBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF5D5DA8), size: 26),
          ),
        ),
        title: const Text(
          "Your Badges",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF5D5DA8),
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CupertinoActivityIndicator(radius: 20));
          }

          final userBadges = Map<String, dynamic>.from(
            snapshot.data!.get('badges') ?? {},
          );

          final unlockedCount = userBadges.values.where((v) => v == true).length;
          final totalCount = allBadges.length;

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Progress Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6C63FF), Color(0xFF5D5DA8)],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6C63FF).withOpacity(0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          "$unlockedCount / $totalCount",
                          style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const Text(
                          "Badges Unlocked",
                          style: TextStyle(fontSize: 18, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Badges Grid
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 18,
                    mainAxisSpacing: 18,
                    childAspectRatio: 0.75,
                  ),
                  delegate: SliverChildBuilderDelegate(
                        (context, i) {
                      final badge = allBadges[i];
                      final bool unlocked = userBadges[badge['id']] == true;

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeOut,
                        child: Column(
                          children: [
                            // Badge Circle
                            Container(
                              width: 84,
                              height: 84,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: unlocked
                                    ? LinearGradient(
                                  colors: badge['gradient'],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                                    : null,
                                color: unlocked ? null : Colors.grey.shade200,
                                boxShadow: unlocked
                                    ? [
                                  BoxShadow(
                                    color: (badge['shadow'] as Color).withOpacity(0.6),
                                    blurRadius: 16,
                                    offset: const Offset(0, 8),
                                  ),
                                ]
                                    : null,
                              ),
                              child: Center(
                                child: unlocked
                                    ? ClipOval(
                                  child: Image.asset(
                                    badge['image'],
                                    fit: BoxFit.cover,
                                    width: 70,
                                    height: 70,
                                  ),
                                )
                                    : const Icon(Icons.lock, size: 36, color: Colors.grey),
                              ),
                            ),

                            const SizedBox(height: 10),

                            // Name
                            Text(
                              badge['name'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: unlocked ? FontWeight.bold : FontWeight.w500,
                                color: unlocked ? Colors.black87 : Colors.grey.shade500,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),

                            const SizedBox(height: 4),

                              Text(
                                badge['desc'],
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 10, color: Colors.grey),
                              )

                          ],
                        ),
                      );
                    },
                    childCount: allBadges.length,
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          );
        },
      ),
    );
  }
}
