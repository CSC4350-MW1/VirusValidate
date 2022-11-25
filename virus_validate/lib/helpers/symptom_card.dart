import 'package:flutter/material.dart';

class SymptomCard extends StatelessWidget {
  const SymptomCard({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Text(text),
    );
  }
}