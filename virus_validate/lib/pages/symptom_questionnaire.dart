import 'package:flutter/material.dart';
import 'package:virus_validate/firestore_service.dart';
import 'package:virus_validate/helpers/symptom_card.dart';
import 'package:virus_validate/style/style.dart';

class SymptomQuestionnaire extends StatefulWidget {
  const SymptomQuestionnaire({super.key});
  
  @override
  State<StatefulWidget> createState() => _SymptomQuestionnaireState();
}

class _SymptomQuestionnaireState extends State<SymptomQuestionnaire> {
  final FirestoreService _fs = FirestoreService();
  final String? uid = FirestoreService().getUserID();
  List<String> symptoms = [
    "Fever or chills",
    "New or unexplained cough, shortness of breath, or difficulty breathing",
    "New or unexplained loss of taste or smell",
    "New or unexplained muscle aches",
    "Painful or itchy rash, particularly around or on the genitals or anus"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Health Screen"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: myHeaderText("Have you experienced any of the following symptoms within the last 48 hours?"),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: symptoms.length,
            itemBuilder: (context, index) {
              return SymptomCard(text: symptoms[index]);
            },
            physics: const NeverScrollableScrollPhysics(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: ElevatedButton(
                onPressed: (() {
                  
                }), 
                child: const Text("Yes")
              ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: ElevatedButton(
                onPressed: (() {
                  
                }), 
                child: const Text("No")
              ),
              ),
            ],
          )
        ]
      ),
    );
  }
}