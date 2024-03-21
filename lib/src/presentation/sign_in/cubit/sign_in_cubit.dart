import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../config/di/di.dart';
import '../../../data/local/secure_storage_manager.dart';
import '../../../data/local/shared_preferences_manager.dart';
import '../../../data/remote/auth_client.dart';
part 'sign_in_state.dart';
part 'sign_in_cubit.freezed.dart';

@singleton
class SignInCubit extends Cubit<SignInState> {
  SignInCubit() : super(const SignInState());

  UserCredential? userCredential;

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(signInStatus: SignInStatus.loading));
    try {
      userCredential = await getIt<AuthClient>().signWithEmailAndPassword(
        email: email,
        password: password,
      );
      await getIt<SecureStorageManager>()
          .write(SecureStorageKeys.password.name, password);

      emit(state.copyWith(
        signInStatus: SignInStatus.success,
        email: email,
        password: password,
      ));
    } on FirebaseException catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.message ?? '',
          signInStatus: SignInStatus.error,
        ),
      );
    }
  }

  void backRoute(SignInStepEnum signInStepEnum) {
    switch (state.signInStepEnum) {
      case SignInStepEnum.inputEmail:
        break;
      case SignInStepEnum.verifyCode:
        emit(
          state.copyWith(signInStepEnum: SignInStepEnum.inputEmail),
        );
    }
  }

  void initial() {
    emit(
      state.copyWith(
        signInStepEnum: SignInStepEnum.inputEmail,
        isResendCode: false,
      ),
    );
  }

  Future<void> joinWithAnonymous() async {
    emit(state.copyWith(signInStatus: SignInStatus.loading));

    emit(state.copyWith(
      signInStatus: SignInStatus.success,
    ));
  }

  Future<void> signInWithGoogle() async {
    emit(state.copyWith(signInStatus: SignInStatus.loading));
    try {
      userCredential = await getIt<AuthClient>().signWithGoogle();
      await SharedPreferencesManager.setIsLogin(true);
      emit(state.copyWith(
        signInStatus: SignInStatus.success,
      ));
    } on FirebaseException catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.message ?? '',
          signInStatus: SignInStatus.error,
        ),
      );
    }
  }

  Future<void> signInWithFacebook() async {
    emit(state.copyWith(signInStatus: SignInStatus.loading));
    try {
      userCredential = await getIt<AuthClient>().signInWithFacebook();
      emit(state.copyWith(
        signInStatus: SignInStatus.success,
      ));
    } catch (e) {
      print(e);
    }

    // on FirebaseAuthException catch (error) {
    //   if (error.code == 'account-exists-with-different-credential') {
    //     // error.email is null, It was not the case in the past.
    //     final AuthCredential pendingCredential = error.credential!;
    //
    //     await userCredential?.user?.linkWithCredential(pendingCredential);
    //     print('OMG ${FirebaseAuth.instance.currentUser}');
    //     emit(state.copyWith(
    //       signInStatus: SignInStatus.success,
    //     ));
    //
    //     // final List<String> signInMethods = await FirebaseAuth.instance
    //     //     .fetchSignInMethodsForEmail(error.email!);
    //     // print('OMG $signInMethods');
    //     // if (signInMethods.first == 'facebook.com') {
    //     //   final loginResult = await FacebookAuth.instance.login();
    //     //   final accessToken = loginResult.accessToken!;
    //     //   final facebookAuthCredential =
    //     //       FacebookAuthProvider.credential(accessToken.token);
    //     //   final UserCredential userCredential = await FirebaseAuth.instance
    //     //       .signInWithCredential(facebookAuthCredential);
    //     //   await userCredential.user?.linkWithCredential(pendingCredential);
    //     //   print('OMG ${FirebaseAuth.instance.currentUser}');
    //     //   emit(state.copyWith(
    //     //     signInStatus: SignInStatus.success,
    //     //   ));
    //     // }
    //   }
    // }
  }

  Future<void> siginWithApple() async {
    emit(state.copyWith(signInStatus: SignInStatus.loading));
    try {
      await getIt<AuthClient>().signInWithApple();
      emit(state.copyWith(
        signInStatus: SignInStatus.success,
      ));
    } on FirebaseAuthException catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.message ?? '',
          signInStatus: SignInStatus.error,
        ),
      );
    }
  }
}
