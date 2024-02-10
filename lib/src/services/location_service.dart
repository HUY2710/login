import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:location/location.dart';

import '../../app/cubit/language_cubit.dart';
import '../config/di/di.dart';
import '../data/remote/firestore_client.dart';
import '../global/global.dart';

@singleton
class LocationService {
  LocationService();

  Location get _location => Location();

  Future<LatLng> getCurrentLocation() async {
    try {
      final LocationData position = await _location.getLocation();
      final double lat = position.latitude ?? 0;
      final double long = position.longitude ?? 0;
      Global.instance.location = LatLng(lat, long);
      return LatLng(lat, long);
    } catch (error) {
      debugPrint('error:$error');
      return const LatLng(0, 0);
    }
  }

  Stream<LatLng> getLocationStream() {
    final Location location = Location();
    location.enableBackgroundMode(enable: false);
    location.changeSettings(
      distanceFilter: 1,
    );
    return location.onLocationChanged.map((LocationData event) =>
        LatLng(event.latitude ?? 0, event.longitude ?? 0));
  }

  //lắng nghe vị trí user khi app background
  Stream<LatLng> getLocationStreamOnBackground() {
    final Location location = Location();
    location.enableBackgroundMode();
    location.changeSettings(interval: 5000, distanceFilter: 10);
    return location.onLocationChanged.map((LocationData event) =>
        LatLng(event.latitude ?? 0, event.longitude ?? 0));
  }

  Future<void> updateLocationUserForeGround({
    required LatLng latLng,
  }) async {
    final FirestoreClient firestoreClient = FirestoreClient.instance;
    final address = await getCurrentAddress(latLng);
    try {
      await firestoreClient.updateLocation(
        {
          'lat': latLng.latitude,
          'lng': latLng.longitude,
          'address': address,
          'updatedAt': DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {}
  }

  Future<String> getCurrentAddress(LatLng latLng, {int countReload = 0}) async {
    String address = '';
    if (countReload <= 5) {
      final String locale = getIt<LanguageCubit>().state.languageCode;
      try {
        final List<geo.Placemark> placeMarks =
            await geo.placemarkFromCoordinates(
          latLng.latitude,
          latLng.longitude,
          localeIdentifier: locale,
        );
        if (Platform.isIOS) {
          address = _addressForIos(placeMarks, address);
        } else {
          address = _addressForAndroid(placeMarks, address);
        }
      } on PlatformException catch (_) {
        return getCurrentAddress(latLng, countReload: countReload++);
      }
    }

    return address;
  }

  String _addressForAndroid(List<geo.Placemark> placeMarks, String address) {
    try {
      if (placeMarks.isNotEmpty && placeMarks.length >= 3) {
        final String street = _remakeAddress(placeMarks[1].street);
        final String locality = _remakeAddress(placeMarks[3].locality);
        final String subAdministrativeArea =
            _remakeAddress(placeMarks[0].subAdministrativeArea);
        final String administrativeArea =
            _remakeAddress(placeMarks[0].administrativeArea);
        final String country = _remakeAddress(placeMarks[0].country);
        address =
            '$street $locality $subAdministrativeArea $administrativeArea $country';
        return address;
      } else {
        return ' ';
      }
    } catch (_) {
      return ' ';
    }
  }

  String _addressForIos(List<geo.Placemark> placeMarks, String address) {
    final String street = _remakeAddress(placeMarks[0].street);
    final String locality = _remakeAddress(placeMarks[0].subLocality);
    final String subAdministrativeArea =
        _remakeAddress(placeMarks[0].subAdministrativeArea);
    final String administrativeArea =
        _remakeAddress(placeMarks[0].administrativeArea);
    final String country = _remakeAddress(placeMarks[0].country);
    address =
        '$street $locality $subAdministrativeArea $administrativeArea $country';
    return address;
  }

  String _remakeAddress(String? address) {
    if (address != null && address.isNotEmpty) {
      return '$address,';
    }
    return '';
  }
}
