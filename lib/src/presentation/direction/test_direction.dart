import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../config/di/di.dart';
import '../../services/http_service.dart';
import '../map/cubit/tracking_routes/tracking_routes_cubit.dart';

@RoutePage()
class TestDirectionRoutesScreen extends StatefulWidget {
  const TestDirectionRoutesScreen({super.key});

  @override
  _TestDirectionRoutesState createState() => _TestDirectionRoutesState();
}

class _TestDirectionRoutesState extends State<TestDirectionRoutesScreen> {
  GoogleMapController? mapController; //contrller for Google map
  PolylinePoints polylinePoints = PolylinePoints();

  String googleAPiKey = 'AIzaSyBFXmVTugyampjGtaI8ya7XYP2amraze7s';

  Set<Marker> markers = {}; //markers for google map
  Map<PolylineId, Polyline> polylines = {}; //polylines to show direction

  LatLng startLocation = const LatLng(27.6683619, 85.3101895);
  LatLng endLocation = const LatLng(27.6688312, 85.3077329);
  final Set<Polyline> _polylines = {};
  List<LatLng> polylineCoordinates = [];
  @override
  void initState() {
    markers.add(Marker(
      //add start location marker
      markerId: MarkerId(startLocation.toString()),
      position: startLocation, //position of marker
      infoWindow: const InfoWindow(
        //popup info
        title: 'Starting Point ',
        snippet: 'Start Marker',
      ),
    ));

    markers.add(Marker(
      markerId: MarkerId(endLocation.toString()),
      position: endLocation, //position of marker
      infoWindow: const InfoWindow(
        //popup info
        title: 'Destination Point ',
        snippet: 'Destination Marker',
      ),
    ));

    super.initState();
    testRequest();
  }

  Future<void> testRequest() async {
    final Map<String, dynamic> body = {
      'origin': {
        'location': {
          'latLng': {
            'latitude': startLocation.latitude,
            'longitude': startLocation.longitude
          }
        }
      },
      'destination': {
        'location': {
          'latLng': {
            'latitude': endLocation.latitude,
            'longitude': endLocation.longitude
          }
        }
      },
      'travelMode': 'DRIVE',
      'routingPreference': 'TRAFFIC_AWARE'
    };
    final response = await HTTPService().postRequestRoutes(body);
    if (response.statusCode == 200) {
      print('Response body: ${response.body}');
      final Map<String, dynamic> result = jsonDecode(response.body);

      _getPolyline(result['routes'][0]['polyline']['encodedPolyline']);
    } else {
      // Nếu yêu cầu không thành công, bạn có thể xử lý lỗi ở đây
      print('Request failed with status: ${response.statusCode}');
      debugPrint('Request failed with status: ${response.body}');
    }
  }

  Future<void> _getPolyline(String endCodePolyline) async {
    final List<PointLatLng> result =
        polylinePoints.decodePolyline(endCodePolyline);

    if (result.isNotEmpty) {
      for (final point in result) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }

    setState(() {
      _polylines.add(Polyline(
        polylineId: const PolylineId('poly'),
        points: polylineCoordinates,
        color: Colors.blue,
        width: 3,
      ));
    });
    getIt<TrackingRoutesCubit>().update(_polylines);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: startLocation,
          zoom: 16.0,
        ),
        markers: markers,
        polylines: _polylines,
        onMapCreated: (controller) {
          setState(() {
            mapController = controller;
          });
        },
      ),
    );
  }
}
