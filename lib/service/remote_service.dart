import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';

final functions = FirebaseFunctions.instance;

class RemoteService {
  RemoteService() {
    FirebaseFunctions functions = FirebaseFunctions.instance;
    functions.useFunctionsEmulator("10.0.2.2", 8181);
  }
  

  addVideoLog(Map<String,dynamic> logRecord) async {
    try {
      final result =
        await FirebaseFunctions.instance.httpsCallable('addVideoLog').call(logRecord);
    } on Exception catch(e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  removeVideoLog(Map<String, dynamic> logRecord) async {
    try {
      await FirebaseFunctions.instance.httpsCallable('removeVideoLog').call(logRecord);
    } on Exception catch(e) {
      if(kDebugMode) {
        print(e);
      }
    }
  }

}