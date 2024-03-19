import 'package:flutter_bloc/flutter_bloc.dart';

class JoinAnonymousCubit extends Cubit<bool> {
  JoinAnonymousCubit() : super(false);

  void setJoinAnonymousCubit(bool status) {
    emit(status);
  }
}
