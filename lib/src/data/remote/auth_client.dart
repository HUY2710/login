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

  // Future<UserCredential> signWithFacebook() async {
  //   final LoginResult result = await FacebookAuth.instance.login();
  //   if (result.status == LoginStatus.success) {
  //     // Create a credential from the access token
  //     final OAuthCredential credential =
  //         FacebookAuthProvider.credential(result.accessToken!.token);
  //     // Once signed in, return the UserCredential
  //     return FirebaseAuth.instance.signInWithCredential(credential);
  //   }
  //   elseƠ
  // }

  Future<void> sendEmailVerification() async {
    await auth.currentUser?.sendEmailVerification();
  }
}
