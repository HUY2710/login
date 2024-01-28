import 'dart:async';

import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../data/models/store_user/store_user.dart';
import '../../../shared/constants/map_style.dart';
import '../cubit/location_listen/location_listen_cubit.dart';
import '../cubit/tracking_members/tracking_member_cubit.dart';

class CustomMap extends StatefulWidget {
  const CustomMap({
    super.key,
    required this.mapType,
    required this.defaultLocation,
    this.marker,
    required this.mapController,
    required this.locationListenState,
    required this.trackingMemberState,
  });

  final MapType mapType;
  final LatLng defaultLocation;
  final LocationListenState locationListenState;
  final BitmapDescriptor? marker;
  final Completer<GoogleMapController> mapController;
  final TrackingMemberState trackingMemberState;
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
        //generate marker member
        ...widget.trackingMemberState.maybeWhen(
          orElse: () => <Marker>{},
          initial: () {
            return <Marker>{};
          },
          success: (List<StoreUser> members) {
            return members.map((StoreUser e) => _buildFriendMarker(e));
          },
        ),
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

  Marker _buildFriendMarker(StoreUser e) {
    final double lat = e.location?.lat ?? 0;
    final double lng = e.location?.lng ?? 0;
    return Marker(
      anchor: const Offset(0.5, 0.72),
      position: LatLng(lat, lng),
      markerId: MarkerId(e.code),
      icon: e.marker != null
          ? BitmapDescriptor.fromBytes(
              e.marker!,
              size: const Size.fromWidth(30),
            )
          : BitmapDescriptor.defaultMarker,
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    widget.mapController.complete(controller);
    controller.setMapStyle(mapStyle);
  }
}
