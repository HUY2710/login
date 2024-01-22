import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../config/di/di.dart';
import '../../../services/location_service.dart';
import '../widgets/maps/custom_map.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  LatLng _defaultLocation = const LatLng(0, 0);
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  @override
  void initState() {
    getLocationDemo();
    super.initState();
  }

  Future<void> getLocationDemo() async {
    final latLog = await getIt<LocationService>().getCurrentLocation();
    setState(() {
      _defaultLocation = latLog;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomMap(
        key: ValueKey(_defaultLocation),
        defaultLocation: _defaultLocation,
        mapController: _controller,
        mapType: MapType.normal,
      ),
    );
  }
}
