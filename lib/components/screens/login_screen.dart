import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:my_video_log/components/screens/capture_video_screen.dart';
import 'package:my_video_log/components/buttons/rounded_button.dart';
import 'package:my_video_log/components/screens/home_screen.dart';
import 'package:my_video_log/constants.dart';
import 'package:get_it/get_it.dart';
import 'package:my_video_log/service/user_preference_service.dart';
import 'package:my_video_log/service/video_log_service.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _sl = GetIt.instance;

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
                  await _auth.signInWithEmailAndPassword(
                      email: email, password: password);

                  await _sl.get<VideoLogService>().initLogRecord();
                  await _sl.get<UserPreferenceService>().initUserPreference();

                  Navigator.pushNamed(context, HomeScreen.id);
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
