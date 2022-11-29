
import 'package:flutter/material.dart';
import 'package:virus_validate/models/guest_model.dart';
import 'package:virus_validate/style/style.dart';

class GuestDetailCard extends StatelessWidget {
  const GuestDetailCard({super.key, required this.guest});
  final Guest guest;
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.email_sharp),
                myStandardText('Email: '),
                myStandardText(guest.email)
,              ],
            ),
            Row(
              children: [
                Icon(Icons.wysiwyg_sharp,
                  color: (guest.completedHealthScreen) ? Colors.green : Colors.red,
                ),
                myStandardText('Health Screen: '),
                myStandardText((guest.completedHealthScreen) ? "Completed" : "Not Completed")
              ],
            ),
            Row(
              children: [
                Icon(Icons.coronavirus_sharp,
                  // If guest hasn't completed health screen, keep black as color.
                  // Show Red if isSick is true. Show green if false and health 
                  // screen has been filled out
                  color: (guest.completedHealthScreen) ? 
                    ((guest.isSick) ? Colors.red : Colors.green) 
                    : Colors.black,
                ),
                myStandardText('Has Symptoms? : '),
                myStandardText((guest.completedHealthScreen) ?
                  ((guest.isSick) ? "Yes" : "No")
                  : "Health Screen not completed"
                )
              ],
            ),
            Row(
              children: [
                Icon(Icons.key,
                  color: (guest.unlockedDoor) ? Colors.green : Colors.red,
                ),
                myStandardText("Unlocked Door? : "),
                myStandardText((guest.unlockedDoor) ? "Yes" : "No")
              ],
            )
          ],
        ),
      ),
    );
  }
}