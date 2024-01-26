import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'exception_cubit.freezed.dart';
part 'exception_state.dart';

@injectable
class ExceptionCubit extends Cubit<ExceptionState> {
  ExceptionCubit() : super(const ExceptionState.initial());

  void error(String error) {
    emit(ExceptionState.error(error));
  }

  void success(String success) {
    emit(ExceptionState.success(success));
  }

  void reset() {
    emit(const ExceptionState.initial());
  }
}
