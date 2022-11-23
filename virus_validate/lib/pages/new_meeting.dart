import 'package:flutter/material.dart';
import 'package:virus_validate/forms/new_meeting_form.dart';

class NewMeetingPage extends StatefulWidget {
  const NewMeetingPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NewMeetingPageState();
}

class _NewMeetingPageState extends State<NewMeetingPage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Meeting"),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Icon(Icons.send_sharp),
          ),
        ],
      ),
      body: const NewMeetingForm() 
    );
  }
}