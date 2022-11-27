
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:virus_validate/models/meeting_model.dart';

class FirestoreService {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  static Map<String, Meeting> meetingMap = {};

  String getUserID() {
    return auth.currentUser!.uid;
  }

  final meetingCollection = FirebaseFirestore.instance.collection('Meetings');
  final employeeCollection = FirebaseFirestore.instance.collection('Employees');
  final guestCollection = FirebaseFirestore.instance.collection('Guests');

  final StreamController<List<Meeting>> _meetingsController = StreamController<List<Meeting>>();

  Stream<List<Meeting>> get meetings => _meetingsController.stream;

  FirestoreService() {
    // meetingCollection.snapshots().listen(_meetingsUpdated);
  }

  void _meetingsUpdated(QuerySnapshot<Map<String, dynamic>> snapshot) {
    List<Meeting> meetings = _getMeetingsFromSnapshot(snapshot);
    _meetingsController.add(meetings);
  }

  List<Meeting> _getMeetingsFromSnapshot(QuerySnapshot<Map<String, dynamic>> snapshot) {
    List<Meeting> meetings = [];
    for (var doc in snapshot.docs) {
      Meeting meeting = Meeting.fromJson(doc.id, doc.data());
      meetingMap[meeting.id] = meeting;
      meetings.add(meeting);
    }
    return meetings;
  }
}