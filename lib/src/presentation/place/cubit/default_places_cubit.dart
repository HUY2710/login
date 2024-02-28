import 'dart:core';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../data/models/store_place/store_place.dart';
import '../../../gen/assets.gen.dart';
import '../../../global/global.dart';
import '../../../shared/extension/int_extension.dart';

@singleton
class DefaultPlaceCubit extends Cubit<List<StorePlace>?> with HydratedMixin {
  DefaultPlaceCubit() : super(null) {
    hydrate();
  }

  void update(List<StorePlace> listPlace) {
    emit(listPlace);
  }

  @override
  List<StorePlace>? fromJson(Map<String, dynamic> json) {
    if (json['listDefaultPlaces'] != null) {
      // Convert json['listDefaultPlaces'] thành List<StorePlace>
      final List<dynamic> jsonList = json['listDefaultPlaces'];
      final List<StorePlace> placesList =
          jsonList.map((placeJson) => StorePlace.fromJson(placeJson)).toList();
      return placesList;
    }
    return null;
  }

  @override
  Map<String, dynamic>? toJson(List<StorePlace>? state) {
    return {'listDefaultPlaces': state};
  }
}

final List<StorePlace> defaultListPlace = [
  StorePlace(
    idPlace: 24.randomString(),
    iconPlace: Assets.icons.places.icHome.path,
    namePlace: 'Home',
    idCreator: Global.instance.user?.code ?? '',
    colorPlace: 0xffA369FD,
  ),
  StorePlace(
    idPlace: 24.randomString(),
    iconPlace: Assets.icons.places.icBook.path,
    namePlace: 'School',
    idCreator: Global.instance.user?.code ?? '',
    colorPlace: 0xffA369FD,
  ),
  StorePlace(
    idPlace: 24.randomString(),
    iconPlace: Assets.icons.places.icSchool.path,
    namePlace: 'Work',
    idCreator: Global.instance.user?.code ?? '',
    colorPlace: 0xffA369FD,
  )
];
