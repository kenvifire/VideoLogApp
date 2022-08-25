import 'package:flutter/material.dart';

Future<void> showMyDialog(BuildContext context, String title,
    {String? content, String? cancelTitle, String? confirmTitle, VoidCallback? onConfirmed}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: content == null ? null :  SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(content),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(cancelTitle ?? 'Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          confirmTitle == null ? Container(): TextButton(
            child: Text(confirmTitle),
            onPressed: onConfirmed)
        ],
      );
    },
  );
}