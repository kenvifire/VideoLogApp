import 'package:flutter/material.dart';
import 'package:my_video_log/components/screens/camera_home_screen.dart';
import 'package:my_video_log/components/tabs/calender_tab.dart';
import 'package:my_video_log/components/tabs/settings_tab.dart';
import 'package:get_it/get_it.dart';

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

            title: const Text("My Vide Logs",),
            centerTitle: true,
            automaticallyImplyLeading: false,
          ),
          bottomNavigationBar: menu(context),
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

  Widget menu(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: const TabBar(
        // labelColor: Colors.white,
        // unselectedLabelColor: Colors.white70,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: EdgeInsets.all(5.0),
        // indicatorColor: Colors.blue,
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
