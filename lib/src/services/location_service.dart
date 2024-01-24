import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:location/location.dart';

@singleton
class LocationService {
  LocationService();

  Location get _location => Location();

  Future<LatLng> getCurrentLocation() async {
    final LocationData position = await _location.getLocation();
    final double lat = position.latitude ?? 0;
    final double long = position.longitude ?? 0;
    return LatLng(lat, long);
  }

  // Future<void> updateUserForeGround({
  //   required LocationService locationService,
  //   required LatLng latLng,
  //   required String code,
  //   required Battery battery,
  // }) async {
  //   final FirestoreClient firestoreClient = FirestoreClient.instance;
  //   int tempBattery = 0;
  //   try {
  //     tempBattery = await battery.batteryLevel;
  //   } catch (e) {
  //     tempBattery = 100;
  //   }
  //   final data = await locationService.getCurrentAddress(latLng);

  //   final String address = data;

  //   await firestoreClient.updateUser(code, {
  //     'lat': latLng.latitude,
  //     'lon': latLng.longitude,
  //     'address': address,
  //     'batteryLevel': tempBattery,
  //   });
  //   //update local user
  //   final StoreUser? localUser = await firestoreClient.fetchUser(code);
  //   Global.instance.user = localUser;
  // }

  Stream<LatLng> getLocationStream() {
    final Location location = Location();
    location.enableBackgroundMode(enable: false);
    location.changeSettings(
      distanceFilter: 1,
    );
    return location.onLocationChanged.map((LocationData event) =>
        LatLng(event.latitude ?? 0, event.longitude ?? 0));
  }
}
