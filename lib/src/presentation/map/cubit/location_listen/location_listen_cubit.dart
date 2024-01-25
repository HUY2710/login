import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../config/di/di.dart';
import '../../../../data/models/store_location/store_location.dart';
import '../../../../data/remote/firestore_client.dart';
import '../../../../global/global.dart';
import '../../../../services/location_service.dart';
import '../../../../shared/helpers/map_helper.dart';
part 'location_listen_cubit.freezed.dart';
part 'location_listen_state.dart';

@injectable
class LocationListenCubit extends Cubit<LocationListenState> {
  LocationListenCubit() : super(const LocationListenState.initial());
  final LocationService locationService = getIt<LocationService>();
  StreamSubscription<LatLng>? _locationSubscription;
  FirestoreClient fireStoreClient = FirestoreClient.instance;
  Future<void> listenLocation() async {
    final LatLng latLng = await locationService.getCurrentLocation();
    emit(LocationListenState.success(latLng));

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
      final bool shouldUpdateLocation = MapHelper.checkoutRadius(
        LatLng(lastLocation.lat, lastLocation.lng),
        latLng,
        0.03,
      );
      if (shouldUpdateLocation) {
        final String address =
            await locationService.getCurrentAddress(latLng, countReload: 5);
        fireStoreClient.updateLocation({
          'lat': latLng.latitude,
          'lng': latLng.longitude,
          'address': address,
          'updatedAt': DateTime.now(),
        });
      }
    }

    _locationSubscription =
        locationService.getLocationStream().listen((LatLng latLng) async {
      Global.instance.location = latLng;
      final backgroundMode = await Permission.locationAlways.status
          .isGranted; // check xem quyền background mode có được bật hay không
      if (!backgroundMode) {
        //if background mode is off => update user in foreground
        Timer.periodic(const Duration(seconds: 30), (timer) {
          final bool shouldUpdate = MapHelper.checkoutRadius(
            Global.instance.location,
            latLng,
            0.03,
          );
          if (shouldUpdate) {
            locationService.updateLocationUserForeGround(
              latLng: latLng,
            );
          }
        });
      }
      emit(LocationListenState.success(latLng));
    })
          ..onError((err) {
            emit(LocationListenState.failed(err.toString()));
          });
  }

  void cancelListener() {
    _locationSubscription?.cancel();
  }
}
