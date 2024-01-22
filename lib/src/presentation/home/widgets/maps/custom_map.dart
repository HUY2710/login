import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomMap extends StatefulWidget {
  const CustomMap({
    super.key,
    required this.mapType,
    required this.defaultLocation,
    this.marker,
    required this.mapController,
  });

  final MapType mapType;
  final LatLng defaultLocation;
  final BitmapDescriptor? marker;
  final Completer<GoogleMapController> mapController;

  @override
  State<CustomMap> createState() => _CustomMapState();
}

class _CustomMapState extends State<CustomMap> {
  late LatLng _currentLocation = widget.defaultLocation;
  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: widget.defaultLocation,
        zoom: 16,
      ),
      onMapCreated: _onMapCreated,
      markers: <Marker>{
        Marker(
          markerId: const MarkerId('You'),
          anchor: const Offset(0.5, 0.5),
          position: _currentLocation,
          icon: widget.marker ?? BitmapDescriptor.defaultMarker,
        ),
      },
      zoomControlsEnabled: false,
      onCameraMove: (CameraPosition position) {
        _currentLocation = position.target;
      },
      onCameraIdle: () async {},
      compassEnabled: false,
      mapType: widget.mapType,
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    // widget.mapController.complete(controller);
  }
}
