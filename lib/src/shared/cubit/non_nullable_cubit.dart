import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../io/base_input.dart';

class NonNullableValueCubit<T extends BaseInput> extends Cubit<T> {
  NonNullableValueCubit(@factoryParam super.initialState);

  void change(T value) => emit(value);
}
