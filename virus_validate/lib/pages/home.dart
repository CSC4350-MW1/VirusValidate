
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:virus_validate/forms/new_meeting_form.dart';
import 'package:virus_validate/pages/new_meeting.dart';
import 'package:virus_validate/pages/symptom_questionnaire.dart';

class EmployeeHomePage extends StatefulWidget {
  const EmployeeHomePage({Key? key}) : super(key: key);
  
  @override
  State<StatefulWidget> createState() => _EmployeeHomeState();
}

class _EmployeeHomeState extends State<EmployeeHomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meetings"),
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