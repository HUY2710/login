import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class NullableValueCubit<T> extends Cubit<T?> {
  NullableValueCubit(@factoryParam super.initialState);

  void change(T? value) => emit(value);
}
