import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

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

  Future<UserCredential?> signWithGoogle() async {
    final GoogleSignIn googleSignIn =
        GoogleSignIn(scopes: ['profile', 'email']);

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );
      return auth.signInWithCredential(credential);
    } else {
      GoogleSignIn().disconnect();
      return null;
    }
  }

  Future<UserCredential?> signInWithFacebook() async {
    final loginResult = await FacebookAuth.instance.login();

    switch (loginResult.status) {
      case LoginStatus.success:
        final accessToken = loginResult.accessToken;
        if (accessToken != null) {
          return FirebaseAuth.instance.signInWithCredential(
            FacebookAuthProvider.credential(accessToken.token),
          );
        }

      case LoginStatus.cancelled:
        return null;
      case LoginStatus.failed:
      case LoginStatus.operationInProgress:
        throw UnimplementedError('Login Status is not implemented yet.');
    }
    return null;
  }

  Future<AuthorizationCredentialAppleID?> signInWithApple() async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    return credential;
  }
}
