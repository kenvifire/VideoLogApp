import 'package:firebase_auth/firebase_auth.dart';

class UserService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void authWithEmailAndPassword(String email, String password) {
      _auth.signInWithEmailAndPassword(email: email, password: password);
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
