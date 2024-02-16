import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';

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
