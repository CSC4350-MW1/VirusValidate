import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:virus_validate/models/guest_model.dart';
import 'package:virus_validate/models/meeting_model.dart';
import 'package:virus_validate/models/employee_model.dart';

class FirestoreService {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  //note: so the key will be the id of the meeting amd the value will be the actual meeting object we get from meeting_model.dart
  static Map<String, Meeting> meetingMap = {};
  static Map<String, Guest> guestMap = {};
  static Map<String, Employee> employeeMap = {};

  String getUserID() {
    return auth.currentUser!.uid;
  }
  
  final meetingCollection = FirebaseFirestore.instance.collection('Meetings');
  final employeeCollection = FirebaseFirestore.instance.collection('Employees');
  final guestCollection = FirebaseFirestore.instance.collection('Guests');

  final StreamController<List<Meeting>> _meetingsController =
      StreamController<List<Meeting>>();

  Stream<List<Meeting>> get meetings => _meetingsController.stream;

  FirestoreService() {
    guestService();
    employeeService();
    meetingService();
  }

  guestService() {
    db.collection("Guests").snapshots().listen((event) {
      final guests = [];
      final guest_ids = [];
      for (var doc in event.docs) {
        guests.add(doc.data());
        guest_ids.add(doc.id);
      }
      for (var i = 0; i < guests.length; i++) {
        if (guestMap.containsKey(guest_ids[i])) {
          guestMap.update(
              guest_ids[i], (value) => Guest.fromJson(guest_ids[i], guests[i]));
        } else {
          guestMap[guest_ids[i]] = Guest.fromJson(guest_ids[i], guests[i]);
        }
      }
    });
  }

  employeeService() {
    db.collection("Employees").snapshots().listen((event) {
      final employees = [];
      final employee_ids = [];
      for (var doc in event.docs) {
        employees.add(doc.data());
        employee_ids.add(doc.id);
      }
      for (var i = 0; i < employees.length; i++) {
        if (employeeMap.containsKey(employee_ids[i])) {
          employeeMap.update(employee_ids[i],
              (value) => Employee.fromJson(employee_ids[i], employees[i]));
        } else {
          employeeMap[employee_ids[i]] =
              Employee.fromJson(employee_ids[i], employees[i]);
        }
      }
    });
  }

  meetingService() {
    db.collection("Meetings").snapshots().listen((event) {
      final meetings = [];
      final meeting_ids = [];
      for (var doc in event.docs) {
        meetings.add(doc.data());
        meeting_ids.add(doc.id);
      }
      for (var i = 0; i < meetings.length; i++) {
        if (meetingMap.containsKey(meeting_ids[i])) {
          meetingMap.update(meeting_ids[i],
              (value) => Meeting.fromJson(meeting_ids[i], meetings[i]));
        } else {
          meetingMap[meeting_ids[i]] =
              Meeting.fromJson(meeting_ids[i], meetings[i]);
        }
      }
    });
  }

  void _meetingsUpdated(QuerySnapshot<Map<String, dynamic>> snapshot) {
    List<Meeting> meetings = _getMeetingsFromSnapshot(snapshot);
    _meetingsController.add(meetings);
  }

  List<Meeting> _getMeetingsFromSnapshot(
      QuerySnapshot<Map<String, dynamic>> snapshot) {
    List<Meeting> meetings = [];
    for (var doc in snapshot.docs) {
      Meeting meeting = Meeting.fromJson(doc.id, doc.data());
      meetingMap[meeting.id] = meeting;
      meetings.add(meeting);
    }
    return meetings;
  }
}