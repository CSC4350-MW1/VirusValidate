import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:virus_validate/firestore_service.dart';
import 'package:virus_validate/pages/authentication.dart';
import 'package:virus_validate/pages/home.dart';
import 'package:virus_validate/widgets/loading.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirestoreService();
  runApp(VVApp());
}

class VVApp extends StatelessWidget {
  VVApp({super.key});
  final Future<FirebaseApp> _initializer = Firebase.initializeApp();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Virus Validate',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<FirebaseApp>(
        future: _initializer,
        builder: (BuildContext context, AsyncSnapshot<FirebaseApp> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            /* if (_auth.currentUser != null) {
              return const EmployeeHomePage();
            } */
            return const Authentication();
          } else {
            return const Loading();
          }
        },
      ),
    );
  }
}