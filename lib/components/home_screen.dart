import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

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
          body: const TabBarView(
            children: [
              Icon(Icons.camera),
              Icon(Icons.calendar_month),
              Icon( Icons.settings),
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
            text: "Camera",
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
