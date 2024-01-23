import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapItem {
  MapItem({
    required this.asset,
    required this.title,
    required this.type,
  });

  String asset;
  String title;
  MapType type;
}
