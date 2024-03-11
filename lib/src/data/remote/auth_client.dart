import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

class AuthConstant {
  static const String userName = 'userName';
  static const String code = 'code';
}

@singleton
class AuthClient {
  FirebaseAuth get auth => FirebaseAuth.instance;
  Future<UserCredential> createUserWithEmailAndPassword(
      {required String email, required String password}) async {
    final userCredential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential;
  }

  Future<UserCredential> signWithEmailAndPassword(
      {required String email, required String password}) async {
    final userCredential = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential;
  }

  Future<void> sendEmailVerification() async {
    await auth.currentUser?.sendEmailVerification();
  }
}
