// Streak Card Widget
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StreakCard extends StatelessWidget {
  final int currentStreak;
  final int longestStreak;

  const StreakCard({required this.currentStreak, required this.longestStreak});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.fromLTRB(20,30,20,30),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.orange.shade600, Colors.red.shade600]),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.orange.withOpacity(0.4), blurRadius: 20)],
      ),
      child: Row(
        children: [
          Text("$currentStreak", style: TextStyle(fontSize: 44, color: Colors.white)),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("DAY STREAK", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white)),
              Text("Best: $longestStreak days", style: TextStyle(color: Colors.white70,fontSize: 12)),
            ],
          ),
          Spacer(),
          if (currentStreak >= 7)
            Icon(Icons.whatshot, size: 50, color: Colors.yellow),
        ],
      ),
    );
  }
}