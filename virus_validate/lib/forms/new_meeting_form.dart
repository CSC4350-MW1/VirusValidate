
import 'package:flutter/material.dart';
import 'package:virus_validate/firestore_service.dart';
import 'package:virus_validate/helpers/date_input_card.dart';
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
  
  DateTime? meetingDate;
  TimeOfDay? startTime;

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
      meetingDate = selectedDate;
    });
  }

  Future<void> _showTimePicker() async {
    TimeOfDay timeNow = TimeOfDay.now();

    TimeOfDay? pickedTime = await showTimePicker(
      context: context, 
      initialTime: timeNow
    );

    if (pickedTime == null) {
      return ;
    }
    setState(() {
      startTime = pickedTime;
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
              myHeaderText("Meeting Date"),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    Expanded(
                      child: myStandardText((meetingDate != null) ? meetingDate.toString() : "Valid Date not Selected")
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
                    child: myStandardText((startTime != null) ? startTime.toString() : "Valid Start Time not Selected"),
                  ),
                  GestureDetector(
                    onTap: () {
                      _showTimePicker();
                    },
                    child: const Icon(Icons.alarm_add_sharp),
                  )
                ],
              ),
              const Divider(
                thickness: 3.0
              ),
              myHeaderText("Guests"),
             /*  ListView.builder(
                itemBuilder: itemBuilder
                ), */
            ],
          ),
        ),
      )
    );
  }
}