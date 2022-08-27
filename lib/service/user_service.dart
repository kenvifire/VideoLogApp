import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:my_video_log/service/remote_service.dart';
class UserService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _sl = GetIt.I;

  authWithEmailAndPassword(String email, String password) async {
      final cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
      initUserData();
      return cred;
  }

  createWithEmailAndPassword({required String email, required String password}) async {
      final user = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      initUserData();
      return user;
  }

  void initUserData() {
    final uid = _sl.get<UserService>().getUser()!.uid;
    _sl.get<RemoteService>().initUserData(uid);
  }


  User? getUser() {
    return _auth.currentUser;
  }

  void signOut() async {
    await _auth.signOut();
  }

  bool isLoggedIn() {
    return _auth.currentUser != null;
  }

}
