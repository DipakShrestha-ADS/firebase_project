import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthServices {
  final _firebaseAuthInstance = FirebaseAuth.instance;
  Future<UserCredential> loginUsingEmailAndPassword({required String email, required String password}) async {
    final userCred = await _firebaseAuthInstance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCred;
  }

  Future<UserCredential> registerUsingEmailAndPassword({required String email, required String password}) async {
    final userCred = await _firebaseAuthInstance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCred;
  }

  Future<void> logoutUser() async {
    await _firebaseAuthInstance.signOut();
  }
}
