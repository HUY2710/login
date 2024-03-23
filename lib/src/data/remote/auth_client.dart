import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

import '../../../flavors.dart';

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
    final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['profile', 'email'], forceCodeForRefreshToken: true);

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

  Future<UserCredential?> signInWithApple() async {
    final AuthorizationResult result = await TheAppleSignIn.performRequests(
        [const AppleIdRequest(requestedScopes: [])]);

    if (result.error != null) {
      return null;
    }
    if (result.credential?.identityToken != null &&
        result.credential?.authorizationCode != null) {
      final AuthCredential credential = OAuthProvider('apple.com').credential(
        idToken: String.fromCharCodes(result.credential!.identityToken!),
        accessToken:
            String.fromCharCodes(result.credential!.authorizationCode!),
      );
      return await FirebaseAuth.instance.signInWithCredential(credential);
    }
    return null;
  }
}
