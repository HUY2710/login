import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../src/data/models/last_place_default/last_place_default_model.dart';
import '../../src/shared/cubit/value_cubit.dart';

@singleton
class LastPlaceCubit extends ValueCubit<LastPlaceDefault?> with HydratedMixin {
  LastPlaceCubit() : super(null) {
    hydrate();
  }

  @override
  LastPlaceDefault? fromJson(Map<String, dynamic> json) {
    if (json['lastPlace'] != null) {
      final lastPlace = LastPlaceDefault.fromJson(json['lastPlace']);
      if (json['lastTime'] != null) {
        return lastPlace;
      }
      return lastPlace;
    }

    return null;
  }

  @override
  Map<String, dynamic> toJson(LastPlaceDefault? state) {
    return {'lastPlace': state};
  }
}
