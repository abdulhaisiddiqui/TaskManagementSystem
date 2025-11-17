import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeBuildTaskCard extends StatefulWidget {
  final String title;
  final String time;
  final String category;
  final String status;
  final Color statusColor;
  const HomeBuildTaskCard({super.key,
    required this.title,
    required this.time,
    required this.category,
    required this.status,
    required this.statusColor});

  @override
  State<HomeBuildTaskCard> createState() => _HomeBuildTaskCardState();
}

class _HomeBuildTaskCardState extends State<HomeBuildTaskCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0XFFB5B5B5).withOpacity(0.4),
        borderRadius: BorderRadius.circular(35),
        // border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 6, backgroundColor: Colors.orange[700]),
              const SizedBox(width: 8),
              Text(
                widget.time,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            widget.title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                'Category: ${widget.category}',
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),
              const SizedBox(width: 16),
              Text(
                'Status: ${widget.status}',
                style: TextStyle(
                  fontSize: 13,
                  color: widget.statusColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _actionButton('Edit', Colors.orange),
              _actionButton('Complete', Colors.green),
              _actionButton('Delete', Colors.red),
            ],
          ),
        ],
      ),
    );
  }
  Widget _actionButton(String label, Color color) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        minimumSize: const Size(80, 36),
      ),
      child: Text(label, style: const TextStyle(fontSize: 13)),
    );
  }
}
