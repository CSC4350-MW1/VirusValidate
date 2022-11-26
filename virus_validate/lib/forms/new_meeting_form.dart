
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:virus_validate/firestore_service.dart';
import 'package:virus_validate/style/style.dart';

class NewMeetingForm extends StatefulWidget {
  const NewMeetingForm({Key? key}) : super(key: key);

  @override 
  State<NewMeetingForm> createState() => _NewMeetingFormState();
}

class _NewMeetingFormState extends State<NewMeetingForm> {
  final FirestoreService _fs = FirestoreService();

  bool loading = false;
  final _formKey = GlobalKey<FormState>();

  DateFormat myDateFormat = DateFormat('MM-dd-yyyy');
  DateFormat myTimeFormat = DateFormat('h:mm a');
  
  DateTime? meetingDateStartTime;
  DateTime? meetingDateEndTime;

  TextEditingController meetingTitle = TextEditingController();

  List<TextEditingController> guestEmails = <TextEditingController>[];
  
  
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                child: TextField(
                  controller: meetingTitle,
                  minLines: 1,
                  maxLines: 2,
                  decoration: inputStyling('Meeting Title'),
                ),
              ),
              const Divider(thickness: 3.0,), 
              myHeaderText("Meeting Date"),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
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
              ),
              const Divider(
                thickness: 3.0,
              ),
              myHeaderText("Start Time"),
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
              const Divider(thickness: 3.0,),
              myHeaderText("End Time"),
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
              const Divider(
                thickness: 3.0
              ),
              Row(
                children: [
                  Expanded(child: myHeaderText("Guests")),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        guestEmails.add(TextEditingController());
                      });
                    },
                    child: const Icon(Icons.add),
                  )
                ],
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
    );
  }
}