import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'user_controller_cubit.freezed.dart';
part 'user_controller_state.dart';

class UserControllerCubit extends Cubit<UserControllerState> {
  UserControllerCubit() : super(const UserControllerState.initial());
}
