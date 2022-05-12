import 'package:flutter/material.dart';
import 'package:my_video_log/components/screens/capture_video_screen.dart';
import 'package:camera/camera.dart';
import 'package:my_video_log/components/tabs/setting_tab.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatelessWidget {
  static String id = "home_screen";
  final CameraDescription camera;
  final User user;
  const HomeScreen({Key? key, required this.camera, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blueAccent,
            title: const Text("My Vide Logs"),
          ),
          bottomNavigationBar: menu(),
          body: TabBarView(
            children: [
              CaptureVideoScreen(camera: camera),
              const Icon(Icons.calendar_month),
              SettingTab(user: user),
            ],
          ),

        ),
      ),
    );
  }

  Widget menu() {
    return Container(
      color: Colors.blueAccent,
      child: const TabBar(
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white70,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: EdgeInsets.all(5.0),
        indicatorColor: Colors.blue,
        tabs: [
          Tab(
            text: "New Video",
            icon: Icon(Icons.camera_alt),
          ),
          Tab(
            text: "My Videos",
            icon: Icon(Icons.calendar_today_outlined),
          ),
          Tab(
            text: "Settings",
            icon: Icon(Icons.settings),
          )
        ],
      ),
    );
  }
}
