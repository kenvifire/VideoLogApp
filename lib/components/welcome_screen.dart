import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../components/rounded_button.dart';
import '../components/login_screen.dart';
import '../components/registration_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome_screen';

  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: SizedBox(
                    child: Image.asset('images/logo.png'),
                    height: 60.0,
                  ),
                ),
                AnimatedTextKit(animatedTexts: [
                  TypewriterAnimatedText(
                    'My Video Logs',
                    textStyle: const TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    ),
                    speed: const Duration(milliseconds: 200),
                  )
                ],
                  pause: const Duration(milliseconds: 1000),
                ),
                // Text(
                // 'Flash Chat',
                //      style: TextStyle(
                //        fontSize: 45.0,
                //        fontWeight: FontWeight.w900,
                //        color: Colors.red
                //      ),
                // ),
              ],
            ),
            const SizedBox(
              height: 48.0,
            ),
            RoundedButton(title: 'Login', color: Colors.lightBlue,
            onPressed: () {
              Navigator.pushNamed(context, LoginScreen.id);
            },),
            RoundedButton(title: 'Register', color: Colors.blueAccent,
            onPressed: () { 
              Navigator.pushNamed(context, RegistrationScreen.id);
            },),
          ],
        ),
      ),
    );
  }
}


