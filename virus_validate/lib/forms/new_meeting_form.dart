
import 'package:flutter/material.dart';
import 'package:virus_validate/firestore_service.dart';
import 'package:virus_validate/helpers/date_input_card.dart';

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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 10.0,),
              const Text("Meeting Date"),
              Row(
                children: [
                  Expanded(
                    child: Text((meetingDate != null) ? meetingDate.toString() : "Valid Date not Selected")
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
      )
    );
  }
}