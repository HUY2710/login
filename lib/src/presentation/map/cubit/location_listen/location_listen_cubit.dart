import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';

import '../../../../config/navigation/app_router.dart';
import '../../../../global/global.dart';
import '../../../../services/location_service.dart';
part 'location_listen_cubit.freezed.dart';
part 'location_listen_state.dart';

@injectable
class LocationListenCubit extends Cubit<LocationListenState> {
  LocationListenCubit({required this.locationService, required this.appRouter})
      : super(const LocationListenState.initial());
  final LocationService locationService;
  final AppRouter appRouter;

  BitmapDescriptor? marker;
  StreamSubscription<LatLng>? _locationSubscription;

  Future<void> listenLocation() async {
    final LatLng latLng = await locationService.getCurrentLocation();

    emit(LocationListenState.success(latLng));
    _locationSubscription =
        locationService.getLocationStream().listen((LatLng latLng) async {
      Global.instance.location = latLng;
      emit(LocationListenState.success(latLng));
    })
          ..onError((err) {
            emit(LocationListenState.failed(err.toString()));
          });
  }

  void cancelListener() {
    _locationSubscription?.cancel();
  }
}
