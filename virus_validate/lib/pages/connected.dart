import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:virus_validate/pages/authentication.dart';
import 'package:virus_validate/pages/home.dart';


class Connected extends StatelessWidget {
  Connected({Key? key}) : super(key: key);
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    var stream = _auth.idTokenChanges();
    stream.listen((event) { });
    if (_auth.currentUser != null) {
      return const EmployeeHomePage();
    } else {
      return const Authentication();
    }
  }
}