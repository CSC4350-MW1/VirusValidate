
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:virus_validate/pages/new_meeting.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  
  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
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