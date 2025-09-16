import 'package:flutter/material.dart';

class ActivityItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final DateTime timestamp;
  final Color color;

  ActivityItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.timestamp,
    required this.color,
  });
}