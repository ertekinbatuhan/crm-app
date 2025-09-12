import '../models/meeting_model.dart';

abstract class MeetingService {
  Future<List<Meeting>> getMeetings();
  Future<List<Meeting>> getMeetingsByDate(DateTime date);
  Future<Meeting> createMeeting(Meeting meeting);
  Future<Meeting> updateMeeting(Meeting meeting);
  Future<void> deleteMeeting(String meetingId);
}

class MeetingServiceImpl implements MeetingService {
  final List<Meeting> _meetings = [
    Meeting(
      id: '1',
      title: 'Client meeting with Sarah',
      startTime: DateTime.now().copyWith(hour: 14, minute: 0),
      endTime: DateTime.now().copyWith(hour: 15, minute: 0),
      type: MeetingType.client,
      participants: ['Sarah Johnson'],
      description: 'Discuss project requirements and timeline',
    ),
    Meeting(
      id: '2',
      title: 'Team standup',
      startTime: DateTime.now().copyWith(hour: 9, minute: 30),
      endTime: DateTime.now().copyWith(hour: 10, minute: 0),
      type: MeetingType.internal,
      participants: ['Development Team'],
      description: 'Daily team standup meeting',
    ),
  ];

  @override
  Future<List<Meeting>> getMeetings() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_meetings);
  }

  @override
  Future<List<Meeting>> getMeetingsByDate(DateTime date) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _meetings.where((meeting) {
      return meeting.startTime.year == date.year &&
          meeting.startTime.month == date.month &&
          meeting.startTime.day == date.day;
    }).toList();
  }

  @override
  Future<Meeting> createMeeting(Meeting meeting) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final newMeeting = meeting.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
    );
    _meetings.add(newMeeting);
    return newMeeting;
  }

  @override
  Future<Meeting> updateMeeting(Meeting meeting) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _meetings.indexWhere((m) => m.id == meeting.id);
    if (index != -1) {
      _meetings[index] = meeting;
      return meeting;
    }
    throw Exception('Meeting not found');
  }

  @override
  Future<void> deleteMeeting(String meetingId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _meetings.removeWhere((meeting) => meeting.id == meetingId);
  }
}
