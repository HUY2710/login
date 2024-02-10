import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/store_place/store_place.dart';
import '../cubit/tracking_places/tracking_places_cubit.dart';
import '../models/member_maker_data.dart';
import 'place_marker.dart';

class PlacesMarkerList extends StatefulWidget {
  const PlacesMarkerList({
    super.key,
    required this.trackingPlacesCubit,
  });

  final TrackingPlacesCubit trackingPlacesCubit;

  @override
  State<PlacesMarkerList> createState() => _PlacesMarkerListState();
}

class _PlacesMarkerListState extends State<PlacesMarkerList> {
  final StreamController<MemberMarkerData> _streamController =
      StreamController();

  @override
  void initState() {
    widget.trackingPlacesCubit.generatePlacesMarker(_streamController);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant PlacesMarkerList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.key != widget.key) {
      debugPrint('Khác');
      widget.trackingPlacesCubit.generatePlacesMarker(_streamController);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrackingPlacesCubit, TrackingPlacesState>(
      bloc: widget.trackingPlacesCubit,
      builder: (BuildContext context, TrackingPlacesState state) {
        return state.maybeWhen(
          orElse: () => const SizedBox(),
          initial: () {
            // _streamController.close();
            return const SizedBox();
          },
          success: (List<StorePlace> places) {
            if (places.isNotEmpty) {
              return Stack(
                children: places.map((StorePlace place) {
                  return PlaceMarker(
                    key: UniqueKey(),
                    streamController: _streamController,
                    place: place,
                    index: places.indexOf(place),
                  );
                }).toList(),
              );
            }
            return const SizedBox();
          },
        );
      },
    );
  }
}
