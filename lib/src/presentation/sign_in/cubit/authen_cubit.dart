import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'authen_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(Unauthenticated());

  Future<bool> _isAuthenticated() async {
    return FirebaseAuth.instance.currentUser != null;
  }

  Future<void> appStarted() async {
    if (await _isAuthenticated()) {
      emit(Authenticated());
    } else {
      emit(Unauthenticated());
    }
  }

  void loggedIn() => emit(Authenticated());

  void loggedOut() => emit(Unauthenticated());
}
