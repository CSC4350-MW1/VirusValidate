import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:virus_validate/firestore_service.dart';
import 'package:virus_validate/models/meeting_model.dart';
import 'package:virus_validate/style/style.dart';

class EmployeeMeetingPage extends StatefulWidget {
  const EmployeeMeetingPage({super.key, required this.meeting});
  final Meeting meeting;

  @override
  State<StatefulWidget> createState() => _EmployeeMeetingPageState();
}

class _EmployeeMeetingPageState extends State<EmployeeMeetingPage> {
  final FirestoreService _fs = FirestoreService();

  bool loading = false;
  final _formKey = GlobalKey<FormState>();

  DateFormat myDateFormat = DateFormat('MM-dd-yyyy');
  DateFormat myTimeFormat = DateFormat('h:mm a');
  
  DateTime? meetingDateStartTime;
  DateTime? meetingDateEndTime;

  final TextEditingController _meetingTitle = TextEditingController();
  final TextEditingController _meetingDescription = TextEditingController();

  List<TextEditingController> guestEmails = <TextEditingController>[];

  @override
  void initState() {
    super.initState();
    meetingDateStartTime = widget.meeting.startTime;
    meetingDateEndTime = widget.meeting.endTime;
    _meetingTitle.text = widget.meeting.title;
    _meetingDescription.text = widget.meeting.description;
    for (var email in widget.meeting.guestList.keys) {
      guestEmails.add(TextEditingController(text: email));
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Meeting"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: (() async {
                bool otherFields = true;
                if (meetingDateStartTime == null || meetingDateEndTime == null || guestEmails.isEmpty) {
                  otherFields = false;
                }
                bool result = false;
                if (_formKey.currentState!.validate() && otherFields) {
                  try {
                    result = await createMeeting();
                  } catch(e) {
                    snackBar(context, e.toString());
                  }
                }
                if (result) {
                  Navigator.pop(context);
                }
              }),
              child: const Icon(Icons.send_sharp),
            ),
          ),
        ],
      ),
      body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10.0,),
              Container(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: _meetingTitle,
                  minLines: 1,
                  maxLines: 2,
                  decoration: inputStyling('Meeting Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Title cannot be empty";
                    }
                    return null;
                  },
                ),
              ),
              const Divider(thickness: 3.0,),
              Container(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: _meetingDescription,
                  minLines: 1,
                  maxLines: 2,
                  decoration: inputStyling('Meeting Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Meeting Description cannot be empty";
                    }
                    return null;
                  },
                ),
              ),
              const Divider(thickness: 3.0,),
              Container(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    myHeaderText("Meeting Date"), 
                    const SizedBox(height: 3.0,),                   
                    Row(
                      children: [
                        Expanded(
                          child: myStandardText((meetingDateStartTime != null) ? myDateFormat.format(meetingDateStartTime!) : "Valid Date not Selected")
                        ),
                        GestureDetector(
                          onTap: _showDatePicker,
                          child: const Icon(Icons.calendar_today_sharp),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(
                thickness: 3.0,
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    myHeaderText("Start Time"),
                    const SizedBox(height: 3.0,),
                    Row(
                      children: [
                        Expanded(
                          child: myStandardText((meetingDateStartTime != null) ? myTimeFormat.format(meetingDateStartTime!) : "Valid Start Time not Selected"),
                        ),
                        GestureDetector(
                          onTap: () {
                            _showStartTimePicker();
                          },
                          child: const Icon(Icons.alarm_add_sharp),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(thickness: 3.0,),
              Container(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    myHeaderText("End Time"),
                    const SizedBox(height: 3.0,),
                    Row(
                      children: [
                        Expanded(
                          child: myStandardText((meetingDateEndTime != null) ? myTimeFormat.format(meetingDateEndTime!) : "Valid Start Time not Selected"),
                        ),
                        GestureDetector(
                          onTap: () {
                            _showEndTimePicker();
                          },
                          child: const Icon(Icons.alarm_add_sharp),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(
                thickness: 3.0
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    guestEmails.add(TextEditingController());
                  });
                },
                child: Row(
                  children: const [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          "Guests",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: largeText,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      )
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 10.0),
                      child: Icon(Icons.add),
                    ),
                  ],
                ),
              ),
              
              Expanded(
                child: ListView.builder(
                  itemCount: guestEmails.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                      child: TextFormField(
                        controller: guestEmails[index],
                        decoration: inputStyling("Guest Email"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Email must not be empty";
                          }
                          if (!value.contains('@')) {
                            return "Email is in wrong format";
                          }
                          return null;
                        },
                      )
                    );
                  }
                )
              ),
            ],
          ),
        ),
      )
    ) 
    );
  }
  Future<void> _showDatePicker() async {
    DateTime todaysDate = DateTime.now();

    DateTime? selectedDate = await showDatePicker(
      context: context, 
      initialDate: todaysDate, 
      firstDate: todaysDate, 
      lastDate: DateTime(todaysDate.year + 1, todaysDate.month, todaysDate.day)
    );
    if (selectedDate == null) {
      return ;
    }
    setState(() {
      meetingDateStartTime = selectedDate;
    });
  }

  Future<void> _showStartTimePicker() async {
    TimeOfDay timeNow = TimeOfDay.now();

    TimeOfDay? pickedTime = await showTimePicker(
      context: context, 
      initialTime: timeNow
    );

    if (pickedTime == null) {
      return ;
    }
    setState(() {
      if (meetingDateStartTime != null) {
        meetingDateStartTime = DateTime(meetingDateStartTime!.year, meetingDateStartTime!.month, meetingDateStartTime!.day, pickedTime.hour, pickedTime.minute);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Please select a date before selecting the start time")
        ));
      }
    });
  }

  Future<void> _showEndTimePicker() async {
    TimeOfDay timeNow = TimeOfDay.now();

    TimeOfDay? pickedTime = await showTimePicker(
      context: context, 
      initialTime: timeNow
    );

    if (pickedTime == null) {
      return ;
    }
    setState(() {
      if (meetingDateStartTime != null) {
        meetingDateEndTime = DateTime(meetingDateStartTime!.year, meetingDateStartTime!.month, meetingDateStartTime!.day, pickedTime.hour, pickedTime.minute);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Please select a date and start time before selecting the end time")
        ));
      }
    });
  }

  Future<bool> createMeeting() async {
    if (_formKey.currentState!.validate()) {
      try {
        Map<String, String> guestIDs = {};
        
        for (var guestEmail in guestEmails) {
          try {
            UserCredential registrationResponse = await _fs.auth.createUserWithEmailAndPassword(
            email: guestEmail.text, password: '1234567890');

            // Add email and uid to guestIDs map
            /* guestIDs[guestEmail.text] = registrationResponse.user!.uid;
            _fs.guestCollection.doc(guestIDs[guestEmail.text]).set(
              {
                "email": guestEmail.text,
                "isSick": false,
                "completedHealthScreen": false
              }
            ); */
            //guestIDs[guestEmail.text] = guestEmail.text;
          } catch(e) {
            // Email is already in use
            if (e is PlatformException) {
              // TODO Search Guest Documents with guest email to retrieve uid

            }
          }
          // Create Meeting and store document ID to update user lists
          DocumentReference meetingDoc = await _fs.meetingCollection.add(
            {
              'title': _meetingTitle.text,
              'description': _meetingDescription.text,
              'employee': _fs.getUserID(),
              'startTime': meetingDateStartTime,
              'endTime': meetingDateEndTime,
              'guestList': guestIDs
            }
          );
          
          
          return true;
        }
      } catch(e) {
        snackBar(context, e.toString());
        return false;
      }
    }
    return false;
  }
}