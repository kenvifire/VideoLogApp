
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:my_video_log/components/buttons/rounded_button.dart';
import 'package:my_video_log/components/screens/home_screen.dart';
import 'package:my_video_log/components/screens/reset_password_screen.dart';
import 'package:my_video_log/constants.dart';
import 'package:get_it/get_it.dart';
import 'package:my_video_log/service/user_service.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _sl = GetIt.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late User? loggedInUser;

  String email = "";

  String password = "";
  bool showSpinner = false;
  late String errMsg = "";
  String? emailErr;
  String? passwordErr;

  @override
  void initState() {
    loggedInUser = _auth.currentUser;
    emailErr = null;
    passwordErr = null;
    super.initState();
  }

  void _validate() {
    _validateEmail();
    _validatePassword();
  }

  void _validateEmail() {
    if(_emailController.value.text.isEmpty) {
      setState(() {
        emailErr = 'invalid email';

    });
    }else {
      setState(() {
        emailErr = null;
      });
    }
  }

  void _validatePassword() {
    if(_passwordController.value.text.isEmpty) {
      setState(() {
        passwordErr = 'invalid password';
      });
    } else {
      setState(() {
        passwordErr = null;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
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
                onChanged: (value) {
                  email = value;
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your email',
                    errorText: emailErr ?? ""),
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                onChanged: (value) {
                  password = value;
                },
                // decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your password'),
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your password',
                  errorText: passwordErr ?? "",
                ),
              ),
              Text(errMsg, style: const TextStyle(
                color: Colors.red
              ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 24.0,
              ),
              RoundedButton(title: 'Login', onPressed: () async {
                _validate();
                if(passwordErr != null || emailErr != null) {
                  return;
                }

                setState(() {
                  showSpinner = true;
                });

                try {
                  await _sl.get<UserService>().authWithEmailAndPassword(email, password);

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
              RoundedButton(title: 'Back', onPressed: () {
                Navigator.of(context).pop();
              }),
              TextButton(onPressed: (){
                Navigator.pushNamed(context, ResetPasswordScreen.id);
              }, child: const Text('Forget password?'))
            ],
          ),
        ),

      ),

    );
  }
}
