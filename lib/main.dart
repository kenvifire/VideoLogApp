import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_video_log/components/screens/home_screen.dart';
import 'package:my_video_log/components/screens/login_screen.dart';
import 'package:my_video_log/components/screens/registration_screen.dart';
import 'package:my_video_log/components/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:my_video_log/service/camera_service.dart';
import 'package:my_video_log/service/user_service.dart';
import 'package:my_video_log/service/video_log_service.dart';

late List<CameraDescription> cameras;
late User? user;
final sl = GetIt.instance;
Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setup();
  sl.get<CameraService>().init();

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
        HomeScreen.id: (context) => const HomeScreen(),
      },
    );
  }
}

void setup() {
  sl.registerSingleton<UserService>(UserService());
  sl.registerSingleton<CameraService>(CameraService());
  sl.registerSingleton<VideoLogService>(VideoLogService());
}