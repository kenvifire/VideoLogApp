// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_video_log/components/buttons/rounded_button.dart';


void main() {

  Widget _wrapWithMaterialApp(RoundedButton roundedButton) {
    return MaterialApp(
      home: roundedButton,
    );
  }

  testWidgets('Rounded button smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(_wrapWithMaterialApp(RoundedButton(title: "test", onPressed: () => {},)));

    // Verify that we a text
    expect(find.text("test"), findsOneWidget);

  });


  testWidgets(('onPress called on tapping RoundedButton'), (WidgetTester tester) async {
    var pressed = false;
    await tester.pumpWidget(_wrapWithMaterialApp(RoundedButton(title: "test", onPressed: ()  {
      pressed = true;
    },)));
    await tester.tap((find.byType(RoundedButton)));

    //then
    expect(pressed, true);

  });
}
