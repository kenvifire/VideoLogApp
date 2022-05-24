import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_video_log/components/buttons/rounded_button.dart';
import 'package:get_it/get_it.dart';
import 'package:my_video_log/components/screens/welcome_screen.dart';
import 'package:my_video_log/service/user_service.dart';

final sl = GetIt.instance;
class SettingsTab extends StatefulWidget {
  final User user;
  const SettingsTab({Key? key, required this.user}) : super(key: key);

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(widget.user.email!),
        RoundedButton(title: 'Sign Out', color: Colors.blueAccent,
        onPressed: () {
          sl.get<UserService>().signOut();
          Navigator.of(context).pushNamed(WelcomeScreen.id);

        },)
      ],
    );
  }
}
