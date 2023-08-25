import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../io/base_input.dart';

class NullableValueCubit<T extends BaseInput> extends Cubit<T?> {
  NullableValueCubit(@factoryParam super.initialState);

  void change(T? value) => emit(value);
}
