import 'package:flutter/material.dart';
import 'package:virus_validate/models/meeting_model.dart';
import 'package:virus_validate/pages/edit_meeting_details.dart';

class EmployeeMeetingDetails extends StatefulWidget {
  const EmployeeMeetingDetails({super.key, required this.meeting});
  final Meeting meeting;
  
  @override
  State<StatefulWidget> createState() => _EmployeeMeetingDetailsState();

}

class _EmployeeMeetingDetailsState extends State<EmployeeMeetingDetails> {
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meeting Details'),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => EditMeetingPage(meeting: widget.meeting))
              );
            },
            child: const Icon(Icons.settings),
          ),
        ],
      ),
    );
  }
}