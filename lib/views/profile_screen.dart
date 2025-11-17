// views/screens/profile/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Welcome!", style: const TextStyle(fontSize: 24)),
          Text(user?.email ?? "No email", style: const TextStyle(fontSize: 18)),
          ElevatedButton(
            onPressed: () => FirebaseAuth.instance.signOut(),
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }
}