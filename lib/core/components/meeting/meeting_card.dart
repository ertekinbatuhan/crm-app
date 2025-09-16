import 'package:flutter/material.dart';
import '../../../models/meeting_model.dart';

class MeetingCard extends StatelessWidget {
  final Meeting meeting;
  final VoidCallback? onTap;

  const MeetingCard({super.key, required this.meeting, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1), width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _getMeetingTypeColor().withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                _getMeetingTypeIcon(),
                color: _getMeetingTypeColor(),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meeting.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    meeting.timeRange,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  if (meeting.participants.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      'with ${meeting.participants.join(', ')}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getMeetingTypeColor() {
    switch (meeting.type) {
      case MeetingType.client:
        return const Color(0xFF007AFF);
      case MeetingType.internal:
        return const Color(0xFF34C759);
      case MeetingType.presentation:
        return const Color(0xFFFF9500);
      case MeetingType.followUp:
        return const Color(0xFFAF52DE);
    }
  }

  IconData _getMeetingTypeIcon() {
    switch (meeting.type) {
      case MeetingType.client:
        return Icons.people;
      case MeetingType.internal:
        return Icons.group;
      case MeetingType.presentation:
        return Icons.slideshow;
      case MeetingType.followUp:
        return Icons.call;
    }
  }
}
