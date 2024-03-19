// ignore_for_file: use_if_null_to_convert_nulls_to_bools

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../config/di/di.dart';
import '../../../data/local/secure_storage_manager.dart';
import '../../../data/remote/auth_client.dart';
part 'sign_up_cubit.freezed.dart';
part 'sign_up_state.dart';

@singleton
class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(const SignUpState.initial());

  UserCredential? userCredential;

  Future<void> createUser({
    required String email,
    required String password,
  }) async {
    try {
      emit(const SignUpState.loading());

      userCredential = await getIt<AuthClient>().createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // getIt<SharedPreferencesManager>().saveUserUid(
      //   userCredential?.user?.uid ?? '',
      // );
      await getIt<SecureStorageManager>()
          .write(SecureStorageKeys.password.name, password);

      emit(const SignUpState.signUpSccess());
    } on FirebaseAuthException catch (e) {
      emit(SignUpState.error(message: e.message ?? ''));
    }
  }

  Future<void> saveCodeAndUserName(
    String code,
    String userName, {
    bool? isSignUp,
  }) async {
    try {
      final user = getIt<AuthClient>().auth.currentUser;
      final uid =
          isSignUp == true ? '${userCredential?.user?.uid}' : '${user?.uid}';

      if (isSignUp == true) {
        getIt<SecureStorageManager>().write('name_$uid', userName);
      }
      // getIt<SharedPreferencesManager>().savePinCode(code);

      emit(const SignUpState.saveCodeSccess());
    } on FirebaseException catch (e) {
      emit(SignUpState.error(message: e.message ?? ''));
    }
  }
}
