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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            myHeaderText(meeting.title),
            const SizedBox(height: 3.0,),
            Row(
              children: [
                myStandardText('Date: '),
                myStandardText(myDateFormat.format(meeting.startTime))
              ],
            ),
            const SizedBox(height: 3.0,),
            Row(
              children: [
                myStandardText('Start Time:'),
                myStandardText(myTimeFormat.format(meeting.startTime)),
                const SizedBox(width: 10.0,),
                myStandardText('End Time: '),
                myStandardText(myTimeFormat.format(meeting.endTime))
              ],
            ),
          ],
        ),
      )
    );
  }

}