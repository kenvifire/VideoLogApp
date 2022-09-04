import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:my_video_log/components/buttons/rounded_button.dart';
import 'package:my_video_log/components/domains/user_preference.dart';
import 'package:my_video_log/components/screens/welcome_screen.dart';
import 'package:my_video_log/service/purchase_service.dart';
import 'package:my_video_log/service/user_preference_service.dart';
import 'package:my_video_log/service/user_service.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({Key? key}) : super(key: key);

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  final _sl = GetIt.instance;
  bool _saveToCloud = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(_sl.get<UserService>().getUser()!.email!),
        FutureBuilder(
            future: _sl.get<UserPreferenceService>().getUserPreference(),
            builder: (context, snapshot) {
              return _userPreferenceWidget(snapshot);
            }),
        RoundedButton(
          title: 'Sign Out',
          onPressed: () {
            _sl.get<UserService>().signOut();
            Navigator.of(context).pushNamed(WelcomeScreen.id);
          },
        ),
      ],
    );
  }

  Widget _userPreferenceWidget(AsyncSnapshot snapshot) {
    if (snapshot.hasData) {
      var pref = snapshot.data as UserPreference;

      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Save to cloud"),
              Switch(
                value: pref.saveToCloud,
                onChanged: (value) async {
                  await _sl
                      .get<UserPreferenceService>()
                      .updateUserPreference(UserPreference(saveToCloud: value));
                  setState(() {
                    _saveToCloud = value;
                  });
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Upgrade to 5G"),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 4),
                  color: Colors.yellow,
                  shape: BoxShape.circle,
                ),
                child: IconButton(onPressed: () async {
                  List<ProductDetails> products = await _sl.get<PurchaseService>().loadProducts();
                }, icon: const Icon(Icons.shopping_cart)),
              )
            ],
          )
        ],
      );
    } else if (snapshot.hasError) {
      return const Center(
        child: Text("Error loading preference"),
      );
    } else {
      return const Center(
        child: Text("Loading"),
      );
    }
  }
}
