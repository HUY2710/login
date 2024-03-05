import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@singleton
class TimeShowInterCubit extends Cubit<bool> {
  TimeShowInterCubit() : super(true);
  void change(bool value) => emit(value);
  void reset() {
    emit(false);
    Future.delayed(
      const Duration(seconds: 20),
      () {
        emit(true);
      },
    );
  }
}
