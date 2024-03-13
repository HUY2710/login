import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
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

  Future<UserCredential> signWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken,
    );

    await auth.signInWithCredential(credential);
    return auth.signInWithCredential(credential);
  }

  Future<UserCredential> signInWithFacebook() async {
    final loginResult = await FacebookAuth.instance.login();

    switch (loginResult.status) {
      case LoginStatus.success:
        final accessToken = loginResult.accessToken!;

        return await FirebaseAuth.instance.signInWithCredential(
          FacebookAuthProvider.credential(accessToken.token),
        );

      case LoginStatus.cancelled:
        throw FirebaseAuthException(
          code: 'ERROR_FACEBOOK_LOGIN_FAILED',
          message: loginResult.message,
        );
      case LoginStatus.failed:
      case LoginStatus.operationInProgress:
        throw UnimplementedError('Login Status is not implemented yet.');
    }
  }

  Future<UserCredential> signInWithApple() async {
    final appleProvider = AppleAuthProvider();
    return await FirebaseAuth.instance.signInWithProvider(appleProvider);
  }

  Future<void> sendEmailVerification() async {
    await auth.currentUser?.sendEmailVerification();
  }
}
