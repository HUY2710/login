import 'package:bloc/bloc.dart';

class ProductSelectionCubit extends Cubit<int> {
  ProductSelectionCubit(super.value);

  void select(int index) => emit(index);
}
