import 'package:injectable/injectable.dart';

import '../../../data/models/store_user/store_user.dart';
import '../../../shared/cubit/value_cubit.dart';

@singleton
class SelectUserCubit extends ValueCubit<StoreUser?> {
  SelectUserCubit() : super(null);
}
