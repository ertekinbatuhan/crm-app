import 'package:flutter/material.dart';

class MeetingListItem extends StatelessWidget {
  final dynamic meeting;

  const MeetingListItem({
    super.key,
    required this.meeting,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFF007AFF).withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(
          Icons.videocam,
          color: Color(0xFF007AFF),
          size: 20,
        ),
      ),
      title: Text(
        meeting.title ?? 'Meeting',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      subtitle: Text(
        '${_formatTime(meeting.startTime)} - ${_formatTime(meeting.endTime)}',
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 14,
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '${displayHour.toString().padLeft(1, '0')}:${minute.toString().padLeft(2, '0')} $period';
  }
}