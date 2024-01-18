import 'value_cubit.dart';

class RestorableCubit<T> extends ValueCubit<T> {
  RestorableCubit(super.state)
      : initialValue = state,
        savedValue = state;
  final T initialValue;

  T savedValue;

  ///Khôi phục lại state ban đầu
  void restoreToInitialValue() => emit(initialValue);

  ///Lưu lại state
  void saveState() => savedValue = state;

  ///Khôi phục lại state được lưu từ hàm [saveState]
  void restoreToSavedValue() => emit(savedValue);
}
