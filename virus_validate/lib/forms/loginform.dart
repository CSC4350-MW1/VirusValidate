// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:virus_validate/firestore_service.dart';
import 'package:virus_validate/models/meeting_model.dart';
import 'package:virus_validate/pages/authentication.dart';
import 'package:virus_validate/pages/home.dart';
import 'package:virus_validate/style/style.dart';


class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
  
}

class _LoginFormState extends State<LoginForm> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 10,),
              TextFormField(
                controller: _email,
                decoration: inputStyling("Email"),
                validator: (value){
                  if (value == null || value.isEmpty){
                    return "Email cannot be empty";
                  }
                  if (!value.contains('@')) {
                    return "Email is in wrong format";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10,),
               TextFormField(
                controller: _password,
                decoration: inputStyling("Password"),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Password may not be empty";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10,),
              OutlinedButton(
                onPressed: login,child: const Text("Login")),
              const SizedBox(height: 10, ), 
              OutlinedButton(onPressed: () {
                setState(() {
                  forgot();
                });
              }, 
              child: const Text("Forgot Password")
              ),       
            ],
          )
        )
      )
    );
  }

  Future<void> forgot() async {
    if (_email.text.isNotEmpty) {
      _auth.sendPasswordResetEmail(email:  _email.text);
      snackBar(context, "Password reset sent.");
    }
  }

  Future<void> login() async {
    if (_formKey.currentState!.validate()) {
      try{
      UserCredential loginResponse = await _auth.signInWithEmailAndPassword(
      email: _email.text, password: _password.text);

      Widget nextPage = const Authentication();
      log("Employee Map: ${FirestoreService.employeeMap.toString()}");
      log("Guest Map: ${FirestoreService.guestMap.toString()}");
      
      if (loginResponse.user != null) {
        if (FirestoreService.employeeMap.containsKey(loginResponse.user!.uid)) {
          nextPage = const EmployeeHomePage();
        } else if (FirestoreService.guestMap.containsKey(loginResponse.user!.uid)) {
          nextPage = const GuestHomePage();
        }
      }
      if(loginResponse.user!.emailVerified) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (BuildContext context) => nextPage));
      } else {
        snackBar(context, "User logged in but email is not verified");
        loginResponse.user!.sendEmailVerification();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (BuildContext context) => nextPage));
      }

      setState(() {
        loading = false;
      });
      } catch(e) {
        snackBar(context, e.toString());
        loading = false;
      }
    }
  }
}