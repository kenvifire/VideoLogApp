import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingTab extends StatefulWidget {
  final User user;
  const SettingTab({Key? key, required this.user}) : super(key: key);

  @override
  State<SettingTab> createState() => _SettingTabState();
}

class _SettingTabState extends State<SettingTab> {
  @override
  Widget build(BuildContext context) {
    return Container(child: Column(
      children: [
        Text(widget.user.email!),
      ],
    ),);
  }
}
