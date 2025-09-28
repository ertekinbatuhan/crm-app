import '../models/meeting_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

abstract class MeetingService {
  Stream<List<Meeting>> getMeetingsStream();
  Future<List<Meeting>> getMeetingsOnce();
  Future<List<Meeting>> getMeetingsByDate(DateTime date);
  Future<Meeting> createMeeting(Meeting meeting);
  Future<Meeting> updateMeeting(Meeting meeting);
  Future<void> deleteMeeting(String meetingId);
}

class FirebaseMeetingService implements MeetingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collection = 'meetings';

  @override
  Stream<List<Meeting>> getMeetingsStream() {
    try {
      return _firestore
          .collection(_collection)
          .orderBy('startTime', descending: false)
          .snapshots()
          .map(
            (snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              data['id'] = doc.id;
              return Meeting.fromMap(data);
            }).toList(),
          );
    } catch (e) {
      throw Exception('Failed to stream meetings: $e');
    }
  }

  @override
  Future<List<Meeting>> getMeetingsOnce() async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .orderBy('startTime', descending: false)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Meeting.fromMap(data);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch meetings: $e');
    }
  }

  @override
  Future<List<Meeting>> getMeetingsByDate(DateTime date) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final querySnapshot = await _firestore
          .collection(_collection)
          .where(
            'startTime',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay),
          )
          .where('startTime', isLessThan: Timestamp.fromDate(endOfDay))
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Meeting.fromMap(data);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch meetings by date: $e');
    }
  }

  @override
  Future<Meeting> createMeeting(Meeting meeting) async {
    try {
      final meetingId = const Uuid().v4();
      final now = DateTime.now();
      final meetingWithMeta = meeting.copyWith(
        id: meetingId,
        createdAt: now,
        updatedAt: now,
      );
      final meetingData = meetingWithMeta.toMap();
      meetingData.remove('id');

      await _firestore.collection(_collection).doc(meetingId).set(meetingData);

      return meetingWithMeta;
    } catch (e) {
      throw Exception('Failed to create meeting: $e');
    }
  }

  @override
  Future<Meeting> updateMeeting(Meeting meeting) async {
    try {
      if (meeting.id.isEmpty) {
        throw Exception('Meeting ID cannot be empty');
      }

      final updatedMeeting = meeting.copyWith(updatedAt: DateTime.now());
      final meetingData = updatedMeeting.toMap();
      meetingData.remove('id');

      await _firestore
          .collection(_collection)
          .doc(meeting.id)
          .update(meetingData);

      return updatedMeeting;
    } catch (e) {
      throw Exception('Failed to update meeting: $e');
    }
  }

  @override
  Future<void> deleteMeeting(String meetingId) async {
    try {
      if (meetingId.isEmpty) {
        throw Exception('Meeting ID cannot be empty');
      }

      await _firestore.collection(_collection).doc(meetingId).delete();
    } catch (e) {
      throw Exception('Failed to delete meeting: $e');
    }
  }
}
