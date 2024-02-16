import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../data/models/places/place_model.dart';

@singleton
class NearByPlaceCubit extends Cubit<List<Place>?> with HydratedMixin {
  NearByPlaceCubit() : super(null) {
    hydrate();
  }

  void update(List<Place> listPlace) {
    emit(listPlace);
  }

  @override
  List<Place>? fromJson(Map<String, dynamic> json) {
    if (json['listPlaces'] != null) {
      return json['listPlaces'];
    }
    return null;
  }

  @override
  Map<String, dynamic>? toJson(List<Place>? state) {
    return {'listPlaces': state};
  }
}
