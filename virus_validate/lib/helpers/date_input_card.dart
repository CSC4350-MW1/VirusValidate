import 'package:flutter/material.dart';

class DateInputCard extends StatelessWidget {
  DateTime firstDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Date of Meeting"),
        InputDatePickerFormField(
          firstDate: firstDate, 
          lastDate: DateTime(firstDate.year + 1, firstDate.month, firstDate.day)
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime todaysDate = DateTime.now();

    DateTime? selected = await showDatePicker(
      context: context, 
      initialDate: todaysDate, 
      firstDate: todaysDate, 
      lastDate: DateTime(todaysDate.year + 1, todaysDate.month, todaysDate.day)
    );

    if (selected != null) {
      
    }
  }
}