import 'package:cloud_functions/cloud_functions.dart';
import 'package:my_video_log/components/domains/result.dart';

class RemoteService {
  final functions = FirebaseFunctions.instance;

  Future<Result> addVideoLog(Map<String, dynamic> logRecord) async {
    return remoteCall('addVideoLog', logRecord);
  }

  Future<Result> removeVideoLog(String recordId) async {
    return remoteCall('removeVideoLog', {'recordId': 'recordId'});
  }

  Future<Result> initUserData(String userId) async {
    return remoteCall("initUser");
  }

  Future<Result> upgradeUserPlan(Map<String, String> purchaseDetail) async {
    return remoteCall("updateUserPlan", purchaseDetail);
  }

  Future<Result> remoteCall(String method, [dynamic parameters]) async {
    try {
      await FirebaseFunctions.instance.httpsCallable(method).call(parameters);
      return const Result(code: success, success: true);
    } on FirebaseFunctionsException catch (e) {
      return Result(code: e.message!, success: false);
    } catch (e) {
      return const Result(code: unknown, success: false);
    }
  }
}
