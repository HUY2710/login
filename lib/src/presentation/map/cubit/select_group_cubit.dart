import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../data/models/store_group/store_group.dart';
import '../../../shared/cubit/value_cubit.dart';

@singleton
class SelectGroupCubit extends ValueCubit<StoreGroup?> with HydratedMixin {
  SelectGroupCubit() : super(null) {
    hydrate();
  }

  @override
  StoreGroup? fromJson(Map<String, dynamic> json) {
    if (json['currentGroup'] != null) {
      return json['currentGroup'];
    }
    return null;
  }

  @override
  Map<String, dynamic>? toJson(StoreGroup? state) {
    return {
      'currentGroup': state,
    };
  }
}
