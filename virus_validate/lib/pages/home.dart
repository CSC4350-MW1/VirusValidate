import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:virus_validate/firestoreExample/firestore_example.dart';
import 'package:virus_validate/firestore_service.dart';
import 'package:virus_validate/forms/new_meeting_form.dart';
import 'package:virus_validate/helpers/meeting_card.dart';
import 'package:virus_validate/models/meeting_model.dart';
import 'package:virus_validate/pages/employee_meeting_details.dart';
import 'package:virus_validate/pages/new_meeting.dart';
import 'package:virus_validate/pages/symptom_questionnaire.dart';
import 'package:virus_validate/widgets/loading.dart';

class EmployeeHomePage extends StatefulWidget {
  const EmployeeHomePage({Key? key}) : super(key: key);
  
  @override
  State<StatefulWidget> createState() => _EmployeeHomeState();
}

class _EmployeeHomeState extends State<EmployeeHomePage> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _fs = FirestoreService();
  late Stream<QuerySnapshot> _meetingStream;
  @override
  void initState() {
    super.initState();
    String uid = _auth.currentUser!.uid;
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
        title: const Text("Meeting Details"),
        // Logout Button
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: GestureDetector(
            onTap: () {
              
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
                /* return ListTile(
                  title: Text(data['title']),
                  subtitle: Text(data['description']),
                ); */
                Meeting meeting = Meeting.fromJson(document.id, data);
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => EmployeeMeetingPage(meeting: meeting))
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guest Homepage'),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                onPressed: () {
                  
                },
                child: const Text('Health Screening'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                onPressed: () {
                  
                },
                child: const Text('Unlock Door')
              ),
            ),
          ],
        ),
      ),
    );
  }
}