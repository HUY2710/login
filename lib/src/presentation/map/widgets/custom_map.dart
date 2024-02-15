import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../data/models/store_location/store_location.dart';
import '../../../data/models/store_place/store_place.dart';
import '../../../data/models/store_user/store_user.dart';
import '../../../shared/constants/app_constants.dart';
import '../../../shared/constants/map_style.dart';
import '../../home/widgets/bottom_sheet/places/history_place.dart';
import '../../home/widgets/bottom_sheet/show_bottom_sheet_home.dart';
import '../cubit/tracking_location/tracking_location_cubit.dart';
import '../cubit/tracking_members/tracking_member_cubit.dart';
import '../cubit/tracking_places/tracking_places_cubit.dart';

class CustomMap extends StatefulWidget {
  const CustomMap({
    super.key,
    required this.mapType,
    required this.defaultLocation,
    this.marker,
    required this.mapController,
    required this.trackingLocationState,
    required this.trackingMemberState,
    required this.trackingPlacesState,
  });

  final MapType mapType;
  final LatLng defaultLocation;
  final TrackingLocationState trackingLocationState;
  final BitmapDescriptor? marker;
  final Completer<GoogleMapController> mapController;
  final TrackingMemberState trackingMemberState;
  final TrackingPlacesState trackingPlacesState;
  @override
  State<CustomMap> createState() => _CustomMapState();
}

class _CustomMapState extends State<CustomMap> {
  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: widget.defaultLocation,
        zoom: AppConstants.defaultCameraZoomLevel,
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
        ...widget.trackingPlacesState.maybeWhen(
          orElse: () => <Marker>{},
          initial: () {
            return <Marker>{};
          },
          success: (List<StorePlace> places) {
            return places.map((StorePlace place) => _buildPlaceMarker(place));
          },
        ),
        Marker(
          markerId: const MarkerId('You'),
          position: widget.trackingLocationState.maybeWhen(
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
      myLocationButtonEnabled: false,
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
        onTap: () {
          showAppModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (context) => HistoryPlace(idUser: e.code),
          );
        });
  }

  Marker _buildPlaceMarker(StorePlace place) {
    final double lat = StoreLocation.fromJson(place.location!).lat;
    final double lng = StoreLocation.fromJson(place.location!).lng;
    return Marker(
      anchor: const Offset(0.5, 0.72),
      position: LatLng(lat, lng),
      markerId: MarkerId(place.idPlace!),
      icon: place.marker != null
          ? BitmapDescriptor.fromBytes(
              place.marker!,
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
