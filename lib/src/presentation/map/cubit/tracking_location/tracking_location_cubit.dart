import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';

import '../../../../../flavors.dart';
import '../../../../config/di/di.dart';
import '../../../../data/models/store_location/store_location.dart';
import '../../../../data/remote/firestore_client.dart';
import '../../../../global/global.dart';
import '../../../../services/location_service.dart';
import '../../../../shared/helpers/map_helper.dart';

part 'tracking_location_cubit.freezed.dart';
part 'tracking_location_state.dart';

@injectable
class TrackingLocationCubit extends Cubit<TrackingLocationState> {
  TrackingLocationCubit() : super(const TrackingLocationState.initial());
  final LocationService locationService = getIt<LocationService>();
  StreamSubscription<LatLng>? _locationSubscription;
  FirestoreClient fireStoreClient = FirestoreClient.instance;
  Future<void> listenLocation() async {
    final LatLng latLng = await locationService.getCurrentLocation();
    emit(TrackingLocationState.success(latLng));

    //kiểm tra xem vị trí hiện tại so với vị trí cuối cùng trên server
    final StoreLocation? lastLocation = await fireStoreClient.getLocation();

    if (lastLocation == null) {
      final String address =
          await locationService.getCurrentAddress(latLng, countReload: 5);
      fireStoreClient.createNewLocation(
        StoreLocation(
          address: address,
          lat: latLng.latitude,
          lng: latLng.longitude,
          updatedAt: DateTime.now(),
        ),
      );
    }

    if (lastLocation != null) {
      //vị trí lần cuối cùng cập nhật lên server với vị trí hiện tại đã cách nhau hơn 30m
      final bool shouldUpdateLocation = MapHelper.isWithinRadius(
        LatLng(lastLocation.lat, lastLocation.lng),
        latLng,
        30,
      );
      if (shouldUpdateLocation) {
        final String address =
            await locationService.getCurrentAddress(latLng, countReload: 5);
        fireStoreClient.updateLocation({
          'lat': latLng.latitude,
          'lng': latLng.longitude,
          'address': address,
          'updatedAt': DateTime.now().toIso8601String(),
        });
      }
    }

    _locationSubscription =
        locationService.getLocationStream().listen((LatLng latLng) async {
      Global.instance.currentLocation = latLng;

      Timer.periodic(Duration(seconds: Flavor.dev == F.appFlavor ? 15 : 30),
          (timer) {
        final bool shouldUpdate = MapHelper.isWithinRadius(
          Global.instance.serverLocation,
          latLng,
          30,
        );
        if (shouldUpdate) {
          locationService.updateLocationUserForeGround(
            latLng: latLng,
          );
        }
      });
      emit(TrackingLocationState.success(latLng));
    })
          ..onError((err) {
            emit(TrackingLocationState.failed(err.toString()));
          });
  }

  void cancelListener() {
    _locationSubscription?.cancel();
  }
}
