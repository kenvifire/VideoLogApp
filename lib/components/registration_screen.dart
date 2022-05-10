import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:my_video_log/components/capture_video_screen.dart';
import 'package:my_video_log/components/rounded_button.dart';

import '../constants.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = 'registration_screen';

  const RegistrationScreen({Key? key}) : super(key: key);


  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  late String email;
  late String password;
  final _auth = FirebaseAuth.instance;
  String errMsg = "";
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: 180.0,
                child: Image.asset('images/logo.png'),
              ),
              const SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                style: const TextStyle(
                    color: Colors.black
                ),
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your email'),
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                onChanged: (value) {
                  password = value;
                },
                style: const TextStyle(
                  color: Colors.black
                ),
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your password'),
              ),
              Text(errMsg, style: const TextStyle(
                color: Colors.red
              ),textAlign: TextAlign.center,),
              const SizedBox(
                height: 24.0,
              ),
              RoundedButton(title: 'Register', color: Colors.blueAccent, onPressed: () async {
                setState(() {
                  showSpinner = true;
                });
                try {
                  final newUser = await _auth.createUserWithEmailAndPassword(
                      email: email, password: password);
                  setState(() {
                    showSpinner = false;
                  });
                  Navigator.pushNamed(context, CaptureVideoScreen.id);

                } on FirebaseAuthException catch(e) {
                  if (e.code == 'weak-password') {
                      setState(() {
                        errMsg = 'Weak password';
                        showSpinner = false;
                      });
                  } else if (e.code == 'email-already-in-use') {
                      setState(() {
                        errMsg = 'Email already in use';
                        showSpinner = false;
                      });
                  }
                }
              }),
              const SizedBox(height: 4.0,),
              RoundedButton(title: 'Back', color: Colors.blueAccent, onPressed: () {
                Navigator.of(context).pop();
              })
            ],
          ),
        ),
      ),
    );
  }
}
