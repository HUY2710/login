import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../src/shared/cubit/value_cubit.dart';

class RateStatusCubit extends ValueCubit<bool> with HydratedMixin {
  RateStatusCubit() : super(false) {
    hydrate();
  }

  late final _storageKey = runtimeType.toString();

  @override
  bool? fromJson(Map<String, dynamic> json) {
    return json[_storageKey] as bool;
  }

  @override
  Map<String, dynamic>? toJson(bool state) {
    return {
      _storageKey: state,
    };
  }
}
