import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:virus_validate/helpers/meeting_card.dart';
import 'package:virus_validate/models/meeting_model.dart';
import 'package:virus_validate/pages/authentication.dart';
import 'package:virus_validate/pages/edit_meeting_details.dart';
import 'package:virus_validate/pages/meeting_details.dart';
import 'package:virus_validate/pages/new_meeting.dart';
import 'package:virus_validate/pages/symptom_questionnaire.dart';
import 'package:virus_validate/widgets/loading.dart';

class EmployeeHomePage extends StatefulWidget {
  const EmployeeHomePage({Key? key}) : super(key: key);
  
  @override
  State<StatefulWidget> createState() => _EmployeeHomeState();
}

class _EmployeeHomeState extends State<EmployeeHomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late Stream<QuerySnapshot> _meetingStream;

  @override
  void initState() {
    super.initState();
    String uid = _auth.currentUser!.uid;
    DateTime now = DateTime.now();
    log(uid);
    _meetingStream = FirebaseFirestore.instance
      .collection('Meetings')
      .where("employee", isEqualTo: uid)
      .snapshots();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Employee's Meetings"),
        // Logout Button
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: GestureDetector(
            onTap: () {
              _auth.signOut();
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                const Authentication()), (Route<dynamic> route) => false);
            },
            child: const Icon(Icons.logout_sharp),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => const GuestHomePage())
              );
            },
            child: const Icon(Icons.person),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => const SymptomQuestionnaire())
              );
            },
            child: const Icon(Icons.coronavirus_rounded),
          ),
          // Create New Meeting
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => const NewMeetingPage()));
              },
              child: const Icon(Icons.note_add_outlined),
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _meetingStream,
        builder: ((BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("Error Occurred");
          }

          if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData) {
            return const Loading();
          }

          return ListView(
          children: snapshot.data!.docs
              .map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                Meeting meeting = Meeting.fromJson(document.id, data);
                DateTime now = DateTime.now();
                //log("Current time: ${now.toString()}  Meeting Time: ${meeting.startTime.toString()}");
                if (meeting.startTime.compareTo(now) < 0) {
                  return Container();
                }
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => EmployeeMeetingDetails(meeting: meeting))
                    );
                  },
                  child: MeetingCard(meeting: meeting)
                );
              })
              .toList()
              .cast(),
        );

        }),
      ),
    );
  }
}

class GuestHomePage extends StatefulWidget {
  const GuestHomePage({Key? key}) : super(key: key);
  
  @override
  State<StatefulWidget> createState() => _GuestHomePageState();

}

class _GuestHomePageState extends State<GuestHomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late Stream<QuerySnapshot> _meetingStream;

  @override
  void initState() {
    super.initState();
    String uid = _auth.currentUser!.uid;
    _meetingStream = FirebaseFirestore.instance
      .collection('Meetings')
      .where("guestList", arrayContains: uid)
      .snapshots();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Guest's Meetings"),
        // Logout Button
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: GestureDetector(
            onTap: () {
              _auth.signOut();
               Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                const Authentication()), (Route<dynamic> route) => false);
            },
            child: const Icon(Icons.logout_sharp),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => const EmployeeHomePage())
              );
            },
            child: const Icon(Icons.person),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => const SymptomQuestionnaire())
              );
            },
            child: const Icon(Icons.coronavirus_rounded),
          ),
          // Create New Meeting
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => const NewMeetingPage()));
              },
              child: const Icon(Icons.note_add_outlined),
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _meetingStream,
        builder: ((BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("Error Occurred");
          }

          if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData) {
            return const Loading();
          }

          return ListView(
          children: snapshot.data!.docs
              .map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                Meeting meeting = Meeting.fromJson(document.id, data);
                DateTime now = DateTime.now();
                //log("Current time: ${now.toString()}  Meeting Time: ${meeting.startTime.toString()}");
                if (meeting.startTime.compareTo(now) < 0) {
                  return Container();
                }
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => GuestMeetingDetails(meeting: meeting))
                    );
                  },
                  child: MeetingCard(meeting: meeting)
                );
              })
              .toList()
              .cast(),
        );

        }),
      ),
    );
  }
}