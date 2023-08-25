import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class NonNullableValueCubit<T> extends Cubit<T> {
  NonNullableValueCubit(@factoryParam super.initialState);

  void change(T value) => emit(value);
}
