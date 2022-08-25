import 'package:cloud_functions/cloud_functions.dart';
import 'package:my_video_log/components/domains/result.dart';

final functions = FirebaseFunctions.instance;

class RemoteService {
  RemoteService() {
    FirebaseFunctions functions = FirebaseFunctions.instance;
    // functions.useFunctionsEmulator("10.0.2.2", 8181);
  }
  

  Future<Result> addVideoLog(Map<String,dynamic> logRecord) async {
    try {
      await FirebaseFunctions.instance.httpsCallable('addVideoLog').call(logRecord);
      return const Result(code: success, success: true);
    } on FirebaseFunctionsException catch(e) {
        return Result(code: e.message!, success: false);
    } catch(e) {
      return const Result(code: unknown, success: false);
    }
  }

  removeVideoLog(Map<String, dynamic> logRecord) async {
    try {
      await FirebaseFunctions.instance.httpsCallable('removeVideoLog').call({
        'recordId': logRecord['recordId']
      });
    } on FirebaseFunctionsException catch(e) {
        return Result(code: e.message!, success: false);
    } catch(e) {
      return const Result(code: unknown, success: false);
    }
  }
}