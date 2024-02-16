import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../data/models/location/location_model.dart';
import '../../../shared/cubit/value_cubit.dart';

@singleton
class LocationRequestPlaceCubit extends ValueCubit<LocationModel?>
    with HydratedMixin {
  LocationRequestPlaceCubit() : super(null) {
    hydrate();
  }

  @override
  LocationModel? fromJson(Map<String, dynamic> json) {
    if (json['location'] != null) {
      return LocationModel.fromJson(json['location']);
    }
    return null;
  }

  @override
  Map<String, dynamic>? toJson(LocationModel? state) {
    return {'location': state};
  }
}
