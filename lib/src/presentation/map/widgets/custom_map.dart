import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../shared/constants/map_style.dart';
import '../cubit/location_listen/location_listen_cubit.dart';

class CustomMap extends StatefulWidget {
  const CustomMap({
    super.key,
    required this.mapType,
    required this.defaultLocation,
    this.marker,
    required this.mapController,
    required this.locationListenState,
  });

  final MapType mapType;
  final LatLng defaultLocation;
  final LocationListenState locationListenState;
  final BitmapDescriptor? marker;
  final Completer<GoogleMapController> mapController;

  @override
  State<CustomMap> createState() => _CustomMapState();
}

class _CustomMapState extends State<CustomMap> {
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
          position: widget.locationListenState.maybeWhen(
            orElse: () => widget.defaultLocation,
            success: (LatLng latLng) => latLng,
          ),
          icon: widget.marker ?? BitmapDescriptor.defaultMarker,
        ),
      },
      circles: <Circle>{
        Circle(
          circleId: const CircleId('circle_1'),
          center: widget.defaultLocation,
          radius: 100,
          fillColor: const Color(0xffA369FD).withOpacity(0.25),
          strokeColor: const Color(0xffA369FD),
          strokeWidth: 1,
          zIndex: 1,
        )
      },
      zoomControlsEnabled: false,
      onCameraIdle: () async {},
      compassEnabled: false,
      mapType: widget.mapType,
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    widget.mapController.complete(controller);
    controller.setMapStyle(mapStyle);
  }
}
