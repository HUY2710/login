import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../config/di/di.dart';
import '../../global/global.dart';
import '../../services/location_service.dart';
import '../../shared/helpers/capture_widget_helper.dart';
import '../home/widgets/maps/custom_map.dart';
import 'cubit/map_type_cubit.dart';
import 'cubit/tracking_members/tracking_member_cubit.dart';
import 'widgets/member_marker.dart';
import 'widgets/member_marker_list.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  LatLng _defaultLocation = const LatLng(0, 0);
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  final MapTypeCubit _mapTypeCubit = getIt<MapTypeCubit>();
  BitmapDescriptor? marker;
  final _trackingMemberCubit = getIt<TrackingMemberCubit>();
  final GlobalKey<State<StatefulWidget>> myKey =
      GlobalKey<State<StatefulWidget>>();
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
      body: Stack(
        children: [
          Positioned.fill(
            child: Align(
              child: BuildMarker(
                index: 0,
                member: Global.instance.user!,
                callBack: () async {
                  final Uint8List? bytes =
                      await CaptureWidgetHelp.widgetToBytes(myKey);

                  if (bytes != null) {
                    setState(() {
                      marker = BitmapDescriptor.fromBytes(
                        bytes,
                        size: const Size.fromWidth(30),
                      );
                    });
                  }
                },
                keyCap: myKey,
              ),
            ),
          ),
          BlocBuilder<MapTypeCubit, MapType>(
            bloc: _mapTypeCubit,
            builder: (context, state) {
              return CustomMap(
                key: ValueKey(_defaultLocation),
                defaultLocation: _defaultLocation,
                mapController: _controller,
                mapType: state,
                marker: marker,
              );
            },
          ),
        ],
      ),
    );
  }
}
