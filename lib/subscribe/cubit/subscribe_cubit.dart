import 'package:bloc/bloc.dart';

class SubscribeCubit extends Cubit<int> {
  SubscribeCubit(super.value);

  void select(int index) => emit(index);
}
