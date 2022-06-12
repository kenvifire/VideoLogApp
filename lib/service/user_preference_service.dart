import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:my_video_log/components/domains/user_preference.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_video_log/service/user_service.dart';

class UserPreferenceService {
  final _sl = GetIt.instance;
  final _db = FirebaseFirestore.instance;
  final String collectionId = "user_preferences";
  UserPreference? _preference;


  Future<UserPreference> getUserPreference() async {
    // no local cache
    // if(_preference != null) {
    //   return Future(() => _preference!);
    // }

    final user = _sl.get<UserService>().getUser();

    final doc = await _db.collection(collectionId).doc(user!.uid).get();
    final data = doc.data() as Map<String, dynamic>;

    _preference = UserPreference(saveToCloud: data['saveToCloud']);
    return Future(() => _preference!);

  }

  Future<void> updateUserPreference(UserPreference userPreference) async {
    final user = _sl.get<UserService>().getUser();

    await _db.collection(collectionId).doc(user!.uid).update({
      'saveToCloud': userPreference.saveToCloud
    });
  }

  Future<void> initUserPreference() async {
    final uid = _sl.get<UserService>().getUser()!.uid;
    final doc = await _db.collection(collectionId).doc(uid).get();
    if(doc.data() == null) {
      _db.collection(collectionId).doc(uid).set({
        'saveToCloud': false
      });
    }
  }
}