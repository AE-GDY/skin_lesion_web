
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user obj based on firebase user
  /*
  User _userFromFirebaseUser(User user) {
    return user != null ? User(uid: user.uid) : null;
  }
   */

  // auth change user stream
  /*
  Stream<User> get user {
    return _auth.onAuthStateChanged
      //.map((FirebaseUser user) => _userFromFirebaseUser(user));
      .map(_userFromFirebaseUser);
  }
  */

  // sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  // register with email and password
  Future<UserCredential> createUserWithEmailAndPassword(
      String email, String password) async {
    return _auth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  // sign out
  Future<void> signOutUser() async {
    _auth.signOut();
  }
}