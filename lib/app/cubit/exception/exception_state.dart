part of 'exception_cubit.dart';

@freezed
class ExceptionState with _$ExceptionState {
  const factory ExceptionState.initial() = _Initial;

  const factory ExceptionState.success(String successMess) = _Valid;

  const factory ExceptionState.error(String errorMess) = _InValid;
}
