import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_launcher/map_launcher.dart' as mapLauncher;

class MapHelper {
  MapHelper._();

  static double _calculateDistance(double startLatitude, double startLongitude,
      double endLatitude, double endLongitude) {
    const double earthRadius = 6371;

    // Đổi độ sang radian
    final double lat1 = _degreesToRadians(startLatitude);
    final double lon1 = _degreesToRadians(startLongitude);
    final double lat2 = _degreesToRadians(endLatitude);
    final double lon2 = _degreesToRadians(endLongitude);

    final double dLat = lat2 - lat1;
    final double dLon = lon2 - lon1;

    final double a =
        pow(sin(dLat / 2), 2) + cos(lat1) * cos(lat2) * pow(sin(dLon / 2), 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    final double distance = earthRadius * c;
    return distance * 1000; //m
  }

  //kiểm tra xem vị trí mới có nằm trong bán kính vị trí cũ hay không
  static bool isWithinRadius(
      LatLng oldLocation, LatLng newLocation, double radius) {
    final double distance = _calculateDistance(
      oldLocation.latitude,
      oldLocation.longitude,
      newLocation.latitude,
      newLocation.longitude,
    );
    return distance <= radius;
  }
}

// Đổi độ sang radian
double _degreesToRadians(double degrees) {
  return degrees * pi / 180;
}

Future<void> openMapWithDestination({
  required double lat,
  required double long,
  required String title,
}) async {
  final List<mapLauncher.AvailableMap> availableMaps =
      await mapLauncher.MapLauncher.installedMaps;

  final int googleMapIndex = availableMaps
      .indexWhere((element) => element.mapType == mapLauncher.MapType.google);

  mapLauncher.AvailableMap map;

  if (googleMapIndex >= 0) {
    map = availableMaps[googleMapIndex];
  } else {
    final int appleMapIndex = availableMaps
        .indexWhere((element) => element.mapType == mapLauncher.MapType.apple);
    map = availableMaps[appleMapIndex];
  }
  final mapLauncher.Coords destination = mapLauncher.Coords(lat, long);
  await map.showDirections(
    destination: destination,
    destinationTitle: title,
  );
}
