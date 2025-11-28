// lib/core/utils/widgets/homewidgets/task_filter_bar.dart

import 'package:flutter/material.dart';
import 'package:taskapp/viewmodels/task_viewmodel.dart';

import '../../../theme/app_theme_constants.dart'; // ← Sirf yeh import!

class TaskFilterBar extends StatefulWidget {
  final TaskSortBy selectedSort;
  final ValueChanged<TaskSortBy> onSortChanged;
  final Function(String filter, String value) onFilterApplied;

  const TaskFilterBar({
    Key? key,
    required this.selectedSort,
    required this.onSortChanged,
    required this.onFilterApplied,
  }) : super(key: key);

  @override
  State<TaskFilterBar> createState() => _TaskFilterBarState();
}

class _TaskFilterBarState extends State<TaskFilterBar> {
  final GlobalKey _selectedKey = GlobalKey();
  OverlayEntry? _overlayEntry;

  void _showDropdown() {
    final RenderBox renderBox = _selectedKey.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    _overlayEntry?.remove();
    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          GestureDetector(onTap: _closeDropdown, child: Container(color: Colors.transparent)),
          Positioned(
            left: position.dx,
            top: position.dy + size.height + 8,
            width: size.width,
            child: Material(
              elevation: 12,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                child: _buildDropdown(),
              ),
            ),
          ),
        ],
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  Widget _buildDropdown() {
    final options = widget.selectedSort == TaskSortBy.priority
        ? ['All', 'High', 'Medium', 'Low']
        : ['All', 'Personal', 'Work', 'Study', 'Other'];

    return Column(
      children: options.map((option) {
        return InkWell(
          onTap: () {
            widget.onFilterApplied(
              widget.selectedSort == TaskSortBy.priority ? 'priority' : 'category',
              option,
            );
            _closeDropdown();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
            child: Row(
              children: [
                Icon(_getIcon(option), size: 20, color: const Color(0xFF6C63FF)),
                const SizedBox(width: 12),
                Text(option, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  IconData _getIcon(String option) {
    switch (option) {
      case 'All': return Icons.filter_list;
      case 'High': return Icons.flag;
      case 'Medium': return Icons.flag_outlined;
      case 'Low': return Icons.flag_rounded;
      case 'Personal': return Icons.person;
      case 'Work': return Icons.work;
      case 'Study': return Icons.school;
      default: return Icons.category;
    }
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppThemeConstants.borderRadius + 12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 6))],
      ),
      child: Row(
        children: [
          _buildChip("Priority", Icons.flag_rounded, TaskSortBy.priority),
          const SizedBox(width: 8),
          _buildChip("Category", Icons.category_rounded, TaskSortBy.category),
        ],
      ),
    );
  }

  Expanded _buildChip(String label, IconData icon, TaskSortBy sortBy) {
    final bool isSelected = widget.selectedSort == sortBy;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          widget.onSortChanged(sortBy);
          if (isSelected) _showDropdown();
        },
        child: AnimatedContainer(
          key: isSelected ? _selectedKey : null,
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF6C63FF) : Colors.transparent,
            borderRadius: BorderRadius.circular(AppThemeConstants.borderRadius + 8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 19, color: isSelected ? Colors.white : Colors.grey.shade700),
              const SizedBox(width: 6),
              Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: isSelected ? Colors.white : Colors.grey.shade700)),
              if (isSelected) const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white, size: 22),
            ],
          ),
        ),
      ),
    );
  }
}