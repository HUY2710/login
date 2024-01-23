import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../shared/cubit/value_cubit.dart';

@singleton
class MapTypeCubit extends ValueCubit<MapType> with HydratedMixin {
  MapTypeCubit() : super(MapType.hybrid);

  @override
  MapType? fromJson(Map<String, dynamic> json) {
    for (final element in MapType.values) {
      if (element.name == json['mapType']) {
        return element;
      }
    }
    return MapType.hybrid;
  }

  @override
  Map<String, dynamic>? toJson(MapType state) {
    return {
      'mapType': state.name,
    };
  }
}
