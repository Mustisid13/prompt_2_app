import 'package:flutter/material.dart';

class PriorityChip extends StatelessWidget {
  final String priority;

  PriorityChip({required this.priority});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (priority) {
      case 'high':
        color = Colors.red;
        break;
      case 'medium':
        color = Colors.orange;
        break;
      default:
        color = Colors.green;
    }

    return Chip(
      label: Text(priority),
      backgroundColor: color.withOpacity(0.2),
      labelStyle: TextStyle(color: color),
    );
  }
}
