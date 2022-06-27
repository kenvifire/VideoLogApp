import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:my_video_log/components/buttons/rounded_button.dart';
import 'package:my_video_log/components/screens/home_screen.dart';
import 'package:my_video_log/constants.dart';
import 'package:get_it/get_it.dart';
import 'package:my_video_log/service/user_service.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = 'registration_screen';

  const RegistrationScreen({Key? key}) : super(key: key);


  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  late String email;
  late String password;
  final _sl = GetIt.I;
  String errMsg = "";
  bool showSpinner = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repassController = TextEditingController();

  String? emailError;
  String? passwordError;
  String? repasswordError;

  _validate() {
    _validateEmail();
    _validatePassword();
    _validateRepass();
  }

  _validateEmail() {
    setState(() {
      emailError = _emailController.value.text.isEmpty ? 'invalid email' : null;
    });
  }

  _validatePassword() {
      setState(() {
        passwordError = _passwordController.value.text.isEmpty ? 'invalid password' : null;
      });
  }

  _validateRepass() {
    setState(() {
      repasswordError = _repassController.value.text != _passwordController.value.text ? 'Password does not match' : null;
    });
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
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your email',
                  errorText: emailError ?? ""
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your password',
                  errorText: passwordError ?? ""
                ),
              ),
              Text(errMsg, style: const TextStyle(
                color: Colors.red
              ),textAlign: TextAlign.center,),

              TextField(
                controller: _repassController,
                obscureText: true,
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your password again',
                  errorText: repasswordError ?? ""
                ),
              ),
              Text(errMsg, style: const TextStyle(
                  color: Colors.red
              ),textAlign: TextAlign.center,),

              const SizedBox(
                height: 24.0,
              ),
              RoundedButton(title: 'Register', onPressed: () async {
                _validate();
                if(emailError != null || passwordError != null || repasswordError !=null ) {
                  return;
                }

                setState(() {
                  showSpinner = true;
                });
                try {
                  await _sl.get<UserService>().createWithEmailAndPassword(email: _emailController.value.text,
                      password: _passwordController.value.text);
                  setState(() {
                    showSpinner = false;
                  });
                  Navigator.pushNamed(context, HomeScreen.id);

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
