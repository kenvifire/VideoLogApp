import 'package:flutter/material.dart';
import 'package:my_video_log/components/domains/user_preference.dart';
import 'package:my_video_log/components/screens/camera_home_screen.dart';
import 'package:my_video_log/components/screens/capture_video_screen.dart';
import 'package:my_video_log/components/tabs/calender_tab.dart';
import 'package:my_video_log/components/tabs/settings_tab.dart';
import 'package:get_it/get_it.dart';
import 'package:my_video_log/service/camera_service.dart';
import 'package:my_video_log/service/user_preference_service.dart';
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
            automaticallyImplyLeading: false,
          ),
          bottomNavigationBar: menu(),
          body: const TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              CameraExampleHome(),
              CalenderTab(),
              SettingsTab(),
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
