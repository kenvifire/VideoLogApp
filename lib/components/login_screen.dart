import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:my_video_log/components/capture_video_screen.dart';
import 'package:my_video_log/components/rounded_button.dart';

import '../constants.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  late User? loggedInUser;

  late String email;
  late String password;
  bool showSpinner = false;
  late String errMsg = "";

  @override
  void initState() {
    loggedInUser = _auth.currentUser;
    super.initState();
  }


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
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: SizedBox(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              const SizedBox(
                height: 48.0,
              ),
              TextField(
                style: const TextStyle(
                  color: Colors.black,
                ),
                onChanged: (value) {
                  email = value;
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your email'),
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                style: const TextStyle(
                  color: Colors.black,
                ),
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your password'),
              ),
              Text(errMsg, style: const TextStyle(
                color: Colors.red
              ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 24.0,
              ),
              RoundedButton(title: 'Login', color: Colors.blueAccent, onPressed: () async {
                setState(() {
                  showSpinner = true;
                });

                try {
                  final user = await _auth.signInWithEmailAndPassword(
                      email: email, password: password);
                  Navigator.pushNamed(context, CaptureVideoScreen.id);
                  setState(() {
                    showSpinner = false;
                  });
                } on FirebaseAuthException catch(e) {
                  setState(() {
                    showSpinner = false;
                    errMsg = e.message!;
                  });
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
