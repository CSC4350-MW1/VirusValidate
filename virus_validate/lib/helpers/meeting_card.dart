import 'package:flutter/material.dart';
import 'package:virus_validate/models/meeting_model.dart';
import 'package:virus_validate/style/style.dart';

class MeetingCard extends StatelessWidget {
  const MeetingCard({super.key, required this.meeting});
  final Meeting meeting;
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Text(meeting.title),
            Row(
              children: [
                const Text('Date:'),
                Text(myDateFormat.format(meeting.startTime))
              ],
            ),
            Row(
              children: [
                const Text('Start Time:'),
                Text(myTimeFormat.format(meeting.startTime)),
                const Text('End Time'),
                Text(myTimeFormat.format(meeting.endTime))
              ],
            ),
          ],
        ),
      )
    );
  }

}