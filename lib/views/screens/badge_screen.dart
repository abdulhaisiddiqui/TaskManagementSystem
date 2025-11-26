// badges_screen.dart → Profile se link kar dena
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BadgesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> allBadges = [
    {"id": "first_task", "name": "First Step", "icon": "footprints", "desc": "Completed your first task"},
    {"id": "week_warrior", "name": "Week Warrior", "icon": "shield", "desc": "7 day streak"},
    {"id": "month_master", "name": "Month Master", "icon": "crown", "desc": "30 day streak"},
    {"id": "fire_50", "name": "On Fire!", "icon": "fire", "desc": "50 day streak"},
    {"id": "legend_100", "name": "Legend", "icon": "star", "desc": "100 day streak!"},
    {"id": "early_bird", "name": "Early Bird", "icon": "sunrise", "desc": "Task before 9 AM"},
    {"id": "night_owl", "name": "Night Owl", "icon": "moon", "desc": "Task after 10 PM"},
  ];

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(title: Text("Your Badges")),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final badges = Map<String, dynamic>.from(snapshot.data!.get('badges') ?? {});

          return GridView.builder(
            padding: EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 16, mainAxisSpacing: 16),
            itemCount: allBadges.length,
            itemBuilder: (context, i) {
              final badge = allBadges[i];
              final unlocked = badges[badge['id']] == true;

              return Column(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: unlocked ? Colors.amber : Colors.grey.shade300,
                    child: Text(unlocked ? badge['icon'] : "lock", style: TextStyle(fontSize: 32)),
                  ),
                  SizedBox(height: 8),
                  Text(badge['name'], style: TextStyle(fontWeight: unlocked ? FontWeight.bold : FontWeight.normal)),
                  if (!unlocked) Text("Locked", style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              );
            },
          );
        },
      ),
    );
  }
}