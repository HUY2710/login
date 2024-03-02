import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../data/models/store_user/store_user.dart';

@singleton
class UserMapVisibilityCubit extends Cubit<List<StoreUser>?> {
  UserMapVisibilityCubit() : super([]);

  void updateList(List<StoreUser> list) {
    emit(list);
  }
}
