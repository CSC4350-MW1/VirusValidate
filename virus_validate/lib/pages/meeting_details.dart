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
                    String id = widget.meeting.guestList.elementAt(index);
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

class GuestMeetingDetails extends StatefulWidget {
  const GuestMeetingDetails({super.key, required this.meeting});
  final Meeting meeting;
  
  @override
  State<StatefulWidget> createState() => _GuestMeetingDetailsState();

}

class _GuestMeetingDetailsState extends State<GuestMeetingDetails> {
  bool _accessibleTimeRange = false;

  @override void initState() {
    super.initState();
    _accessibleTimeRange = isInTimeRange(widget.meeting);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.meeting.title),
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
              myHeaderText('Guests: ${widget.meeting.guestList.length}'),
              const SizedBox(height: 10.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: ElevatedButton(
                      onPressed: (() {
                        String? id = FirestoreService().getUserID();
                        if (id == null) {
                          snackBar(context, "ID not found");
                        }
                        if (!_accessibleTimeRange) {
                          snackBar(context, "Door access only available within 30 minutes of meeting start time");
                        } 
                        if (!FirestoreService.guestMap[id]!.completedHealthScreen) {
                          snackBar(context, "Health Screen must be completed before gaining building access");
                        }
                        if (FirestoreService.guestMap[id]!.isSick) {
                          snackBar(context, "Access is not granted due to symptoms");
                        }
                        // Code to set door and guest variable in database
                      }),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: (unlockDoor(widget.meeting)) ? Colors.blue[500] : Colors.grey
                      ), 
                      child: const Text("Unlock Door"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: ElevatedButton(
                      onPressed: (() {
                        String? id = FirestoreService().getUserID();
                        if (id == null) {
                          snackBar(context, "ID not found");
                        }
                        if (!_accessibleTimeRange) {
                          snackBar(context, "Door access only available within 30 minutes of meeting start time");
                        } 
                        // Code to set variable in database
                      }),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: (unlockDoor(widget.meeting)) ? Colors.blue[500] : Colors.grey
                      ), 
                      child: const Text("Health Screen"),
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      )
    );
  }

  bool isInTimeRange(Meeting meeting) {
    DateTime now = DateTime.now();
    int minutesIncrement = 30;
    DateTime timeAfterIncrement = now.add(Duration(minutes: minutesIncrement));
    if (timeAfterIncrement.compareTo(meeting.startTime) < 0) {
      return false;
    } else {
      return true;
    }
  }
  bool unlockDoor(Meeting meeting) {
    String? id = FirestoreService().getUserID();
    Guest? guest = FirestoreService.guestMap[id];
    if (guest == null) {
      return false;
    }
    if (!isInTimeRange(meeting)) {
      return false;
    }
    if (!guest.completedHealthScreen) {
      return false;
    }
    if (guest.isSick) {
      return false;
    }
    return true;
  }
} 