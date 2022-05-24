import 'package:flutter/material.dart';
import 'package:my_video_log/components/screens/capture_video_screen.dart';
import 'package:camera/camera.dart';
import 'package:my_video_log/components/tabs/calender_tab.dart';
import 'package:my_video_log/components/tabs/settings_tab.dart';
import 'package:get_it/get_it.dart';
import 'package:my_video_log/service/camera_service.dart';
import 'package:my_video_log/service/user_service.dart';

final sl = GetIt.instance;

class HomeScreen extends StatelessWidget {
  static String id = "home_screen";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blueAccent,
            title: const Text("My Vide Logs"),
          ),
          bottomNavigationBar: menu(),
          body: TabBarView(
            children: [
              CaptureVideoScreen(camera: sl.get<CameraService>().getFirstCamera()),
              const CalenderTab(),
              SettingsTab(user: sl.get<UserService>().getUser()!),
            ],
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
