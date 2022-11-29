import 'package:flutter/material.dart';
import 'package:virus_validate/firestore_service.dart';
import 'package:virus_validate/helpers/guest_detail_card.dart';
import 'package:virus_validate/models/guest_model.dart';
import 'package:virus_validate/models/meeting_model.dart';
import 'package:virus_validate/pages/edit_meeting_details.dart';
import 'package:virus_validate/style/style.dart';

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
        title: Text(widget.meeting.title),
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
          const SizedBox(width: 10.0,)
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              myHeaderText('Meeting Description: '),
              myStandardText(widget.meeting.description),
              const Divider(height: 3.0,),
              myHeaderText('Date:'),
              myStandardText(myDateFormat.format(widget.meeting.startTime)),
              const Divider(height: 3.0,),
              myHeaderText('Start Time:'),
              myStandardText(myTimeFormat.format(widget.meeting.startTime)),
              const Divider(height: 3.0,),
              myHeaderText('End Time:'),
              myStandardText(myTimeFormat.format(widget.meeting.endTime)),
              const Divider(height: 3.0,),
              myHeaderText('Guests:'),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.meeting.guestList.length,
                  itemBuilder: ( (context, index) {
                    String id = widget.meeting.guestList.values.elementAt(index);
                    Guest? guest = FirestoreService.guestMap[id];
                    if (guest != null) {
                      return GuestDetailCard(guest: guest);
                    }
                    else {
                      return myStandardText("Guest email not found");
                    }
                  })
                ),
              )
            ],
          ),
        )
      )
    );
  }
}