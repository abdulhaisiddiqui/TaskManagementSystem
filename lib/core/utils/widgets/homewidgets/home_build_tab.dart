import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeBuildTab extends StatefulWidget {
  final String label;
  final int count;
  final int index;
  final Color color;
  const HomeBuildTab({super.key,required this.label,required this.count,required this.index , required this.color});

  @override
  State<HomeBuildTab> createState() => _HomeBuildTabState();
}

class _HomeBuildTabState extends State<HomeBuildTab> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    bool isSelected = _selectedIndex == widget.index;
    return Expanded(
      child: GestureDetector(
        onTap: () {

        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected ? widget.color : Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              '${widget.label} ${widget.count}',
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
