import 'package:flutter/material.dart';
import 'package:virus_validate/style/style.dart';

class SymptomCard extends StatelessWidget {
  const SymptomCard({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: myStandardText(text)),
    );
  }
}