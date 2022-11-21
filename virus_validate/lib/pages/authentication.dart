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
      appBar: AppBar(title: const Text("SocM"),),
      body: Column(children: [
      Image.asset("images/fistbump@3x.png", width: 300,),
      const LoginForm()
      ],),
    );
  }
}
