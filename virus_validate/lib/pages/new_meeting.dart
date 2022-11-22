import 'package:flutter/material.dart';
import 'package:virus_validate/firestore_service.dart';

class NewMeetingPage extends StatefulWidget {
  const NewMeetingPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NewMeetingPageState();
}

class _NewMeetingPageState extends State<NewMeetingPage> {
  final FirestoreService _fs = FirestoreService();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
    );
  }
}