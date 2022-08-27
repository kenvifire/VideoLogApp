
class Result {
  final String code;
  final bool success;

  const Result({required this.code, required this.success});
}

const String success = "success";
const String usageExceed = "usage exceed";
const String unknown = "unknown";
const String loginFailed = "login failed";