import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../flavors.dart';
import '../../../config/di/di.dart';
import '../../../data/models/store_location/store_location.dart';
import '../../../data/models/store_place/store_place.dart';
import '../../../data/models/store_user/store_user.dart';
import '../../../global/global.dart';
import '../../../shared/constants/app_constants.dart';
import '../../../shared/constants/map_style.dart';
import '../../home/widgets/bottom_sheet/show_bottom_sheet_home.dart';
import '../../place/history_place/history_place.dart';
import '../cubit/select_group_cubit.dart';
import '../cubit/tracking_location/tracking_location_cubit.dart';
import '../cubit/tracking_members/tracking_member_cubit.dart';
import '../cubit/tracking_places/tracking_places_cubit.dart';
import '../cubit/user_map_visibility/user_map_visibility_cubit.dart';

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
    this.polylines,
  });

  final MapType mapType;
  final LatLng defaultLocation;
  final TrackingLocationState trackingLocationState;
  final BitmapDescriptor? marker;
  final Completer<GoogleMapController> mapController;
  final TrackingMemberState trackingMemberState;
  final TrackingPlacesState trackingPlacesState;
  final Set<Polyline>? polylines;
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
        if (getIt<SelectGroupCubit>().state == null)
          Marker(
            position: Global.instance.currentLocation,
            markerId: MarkerId(Global.instance.user?.code ?? ''),
            icon: Global.instance.myMarker ?? BitmapDescriptor.defaultMarker,
          )
      },
      circles: <Circle>{
        ...widget.trackingPlacesState.maybeWhen(
          orElse: () => <Circle>{},
          initial: () {
            return <Circle>{};
          },
          success: (List<StorePlace> places) {
            return places.map(
              (StorePlace place) => Circle(
                circleId: CircleId(place.idPlace.toString()),
                center: LatLng(place.location!['lat'], place.location!['lng']),
                radius: place.radius,
                fillColor: Color(place.colorPlace).withOpacity(0.25),
                strokeColor: Color(place.colorPlace),
                strokeWidth: 1,
              ),
            );
          },
        ),
        Circle(
          circleId: const CircleId('circle_1'),
          center: Global.instance.currentLocation,
          radius: 30,
          fillColor: const Color(0xffA369FD).withOpacity(0.25),
          strokeColor: const Color(0xffA369FD),
          strokeWidth: 1,
          zIndex: 1,
        )
      },
      zoomControlsEnabled: false,
      onCameraIdle: () async {
        final mapController = await widget.mapController.future;
        mapController.getVisibleRegion().then((visibleRegion) async {
          widget.trackingMemberState.maybeWhen(
            orElse: () {},
            initial: () {},
            success: (List<StoreUser> members) {
              final List<StoreUser> temp =
                  List.from(getIt<UserMapVisibilityCubit>().state ?? []);
              for (final member in members) {
                final memberExists = temp.contains(member); //
                final LatLng latLngMember = LatLng(
                    member.location?.lat ?? 0, member.location?.lng ?? 0);
                if (!visibleRegion.contains(latLngMember)) {
                  if (!memberExists) {
                    temp.add(member);
                  }
                } else {
                  if (memberExists) {
                    temp.remove(member);
                  }
                }
              }
              getIt<UserMapVisibilityCubit>().updateList([...temp]);
            },
          );
        });
      },
      compassEnabled: false,
      mapType: widget.mapType,
      myLocationButtonEnabled: false,
      polylines: widget.polylines ?? {},
    );
  }

  Marker _buildFriendMarker(StoreUser user) {
    final double lat = user.location?.lat ?? 0;
    final double lng = user.location?.lng ?? 0;
    if (user.code == Global.instance.user?.code && user.marker != null) {
      Global.instance.myMarker = BitmapDescriptor.fromBytes(
        user.marker!,
        size: const Size.fromWidth(30),
      );
    }
    return Marker(
        // anchor: const Offset(0.5, 0.72),
        position: user.code == Global.instance.user?.code
            ? Global.instance.currentLocation
            : LatLng(lat, lng),
        visible: user.marker != null,
        markerId: MarkerId(user.code),
        icon: user.marker != null
            ? BitmapDescriptor.fromBytes(
                user.marker!,
                size: const Size.fromWidth(30),
              )
            : BitmapDescriptor.defaultMarker,
        onTap: user.code == Global.instance.user?.code
            ? () {
                if (Flavor.dev == F.appFlavor) {
                  showAppModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (context) => HistoryPlace(user: user),
                  );
                }
              }
            : () {
                showAppModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) => HistoryPlace(user: user),
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

    controller.getVisibleRegion().then((visibleRegion) async {
      widget.trackingMemberState.maybeWhen(
        orElse: () {},
        initial: () {},
        success: (List<StoreUser> members) {
          final List<StoreUser> temp =
              List.from(getIt<UserMapVisibilityCubit>().state ?? []);
          for (final member in members) {
            final memberExists = temp.contains(member); //
            final LatLng latLngMember =
                LatLng(member.location?.lat ?? 0, member.location?.lng ?? 0);
            if (!visibleRegion.contains(latLngMember)) {
              if (!memberExists) {
                temp.add(member);
              }
            } else {
              if (memberExists) {
                temp.remove(member);
              }
            }
          }
          getIt<UserMapVisibilityCubit>().updateList([...temp]);
        },
      );
    });
  }
}
