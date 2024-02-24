import 'dart:async';

import 'package:flutter/material.dart';
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
import '../../../../services/my_background_service.dart';
import '../../../../services/tracking_history_place_service.dart';
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
      final StoreLocation storeLocation = StoreLocation(
        address: address,
        lat: latLng.latitude,
        lng: latLng.longitude,
        updatedAt: DateTime.now(),
      );
      fireStoreClient.createNewLocation(storeLocation);
      Global.instance.serverLocation = latLng;
      Global.instance.user =
          Global.instance.user?.copyWith(location: storeLocation);
    }

    if (lastLocation != null) {
      //vị trí lần cuối cùng cập nhật lên server với vị trí hiện tại đã cách nhau hơn 30m
      final bool inRadius = MapHelper.isWithinRadius(
        LatLng(lastLocation.lat, lastLocation.lng),
        latLng,
        30,
      );
      if (!inRadius) {
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
        locationService.getLocationStream().listen((LatLng latLngListen) async {
      if (!getIt<MyBackgroundService>().isRunning) {
        Global.instance.currentLocation =
            latLngListen; //cập nhật vị trí hiện tại
      }

      emit(TrackingLocationState.success(latLngListen));
    })
          ..onError((err) {
            emit(TrackingLocationState.failed(err.toString()));
          });

    if (!getIt<MyBackgroundService>().isRunning) {
      Timer.periodic(Duration(seconds: Flavor.dev == F.appFlavor ? 15 : 30),
          (timer) async {
        final bool inRadius = MapHelper.isWithinRadius(
          Global.instance.serverLocation,
          Global.instance.currentLocation,
          30,
        );

        if (!inRadius && !getIt<MyBackgroundService>().isRunning) {
          Global.instance.serverLocation = Global.instance.currentLocation;
          await locationService.updateLocationUser(
            latLng: Global.instance.currentLocation,
          );
          await getIt<TrackingHistoryPlaceService>().trackingHistoryPlace();
        }
      });
    }
  }

  void cancelListener() {
    _locationSubscription?.cancel();
  }
}
