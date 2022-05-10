import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_video_log/components/capture_video_screen.dart';
import 'package:my_video_log/components/home_screen.dart';
import 'package:my_video_log/components/login_screen.dart';
import 'package:my_video_log/components/registration_screen.dart';
import 'package:my_video_log/components/welcome_screen.dart';

late List<CameraDescription> cameras;
Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  cameras = await availableCameras();
  runApp(const MyVideLogApp());
}

class MyVideLogApp extends StatelessWidget {
  const MyVideLogApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        textTheme: const TextTheme(
          bodyText1: TextStyle(color: Colors.black54),
        ),
      ),
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => const WelcomeScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        RegistrationScreen.id: (context) => const RegistrationScreen(),
        CaptureVideoScreen.id: (context) => const HomeScreen(),
      },
    );
  }
}