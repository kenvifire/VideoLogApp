import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:my_video_log/components/buttons/rounded_button.dart';
import 'package:my_video_log/components/screens/home_screen.dart';
import 'package:my_video_log/components/screens/welcome_screen.dart';
import 'package:my_video_log/constants.dart';

class ResetPasswordScreen extends StatefulWidget {
  static String id = 'reset_password_screen';

  const ResetPasswordScreen({Key? key}) : super(key: key);


  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {

  late String email;
  late String password;
  final _auth = FirebaseAuth.instance;
  String errMsg = "";
  bool showSpinner = false;
  String? emailError;
  final _controller = TextEditingController();

  _validate() {
    if(_controller.value.text.isEmpty) {
      setState(() {
        emailError = "invalid email";
      });
    } else {
      setState(() {
        emailError = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                controller: _controller,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your email',
                    errorText: emailError ?? ""
                ),
              ),
              Text(errMsg, style: const TextStyle(
                color: Colors.red
              ),textAlign: TextAlign.center,),
              const SizedBox(
                height: 24.0,
              ),
              RoundedButton(title: 'Reset', onPressed: () async {
                _validate();
                if(emailError != null) {
                  return;
                }
                setState(() {
                  showSpinner = true;
                });
                try {
                  await _auth.sendPasswordResetEmail(email: email );
                  setState(() {
                    showSpinner = false;
                  });

                } on FirebaseAuthException catch(e) {
                      setState(() {
                        errMsg = e.message!;
                        showSpinner = false;
                      });
                  }
                }
              ),
              const SizedBox(height: 4.0,),
              RoundedButton(title: 'Back',  onPressed: () {
                Navigator.of(context).pop();
              })
            ],
          ),
        ),
      ),
    );
  }
}
