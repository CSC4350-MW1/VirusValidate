import 'package:flutter/material.dart';
import 'package:virus_validate/forms/loginform.dart';


class Authentication extends StatefulWidget {
  const Authentication({Key? key}) : super(key: key);

  
  @override
  State<StatefulWidget> createState() => _AuthenticationFormState();
}

class _AuthenticationFormState extends State<Authentication> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Virus Validate"),),
      body: Column(children: [
      const LoginForm(),
      ],),
    );
  }
}
