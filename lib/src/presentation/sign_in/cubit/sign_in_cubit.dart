import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../config/di/di.dart';
import '../../../data/local/secure_storage_manager.dart';
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

  Future<void> signInWithGoogle() async {
    emit(state.copyWith(signInStatus: SignInStatus.loading));
    try {
      userCredential = await getIt<AuthClient>().signWithGoogle();
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
    try {
      emit(state.copyWith(signInStatus: SignInStatus.loading));
      final loginResult = await FacebookAuth.instance.login();

      switch (loginResult.status) {
        case LoginStatus.success:
          final accessToken = loginResult.accessToken!;

          // Here is where the FirebaseAuthException is thrown because
          // email/password exists for the same email.

          FirebaseAuth.instance.signInWithCredential(
            FacebookAuthProvider.credential(accessToken.token),
          );
          emit(state.copyWith(
            signInStatus: SignInStatus.success,
          ));

        case LoginStatus.cancelled:
          throw FirebaseAuthException(
            code: 'ERROR_FACEBOOK_LOGIN_FAILED',
            message: loginResult.message,
          );
        case LoginStatus.failed:
        case LoginStatus.operationInProgress:
          throw UnimplementedError('Login Status is not implemented yet.');
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'account-exists-with-different-credential') {
        // error.email is null, It was not the case in the past.
        await FirebaseAuth.instance.fetchSignInMethodsForEmail(error.email!);
      }
    }
  }
}
