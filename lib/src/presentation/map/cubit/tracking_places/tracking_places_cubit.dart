import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../config/di/di.dart';
import '../../../../data/models/store_place/store_place.dart';
import '../../../../data/remote/firestore_client.dart';
import '../../../../shared/helpers/capture_widget_helper.dart';
import '../../models/member_maker_data.dart';
import '../select_group_cubit.dart';

part 'tracking_places_cubit.freezed.dart';
part 'tracking_places_state.dart';

@singleton
class TrackingPlacesCubit extends Cubit<TrackingPlacesState> {
  TrackingPlacesCubit() : super(const TrackingPlacesState.initial());

  final FirestoreClient _fireStoreClient = FirestoreClient.instance;

  //get list places of group
  List<StorePlace> _trackingListPlaces = <StorePlace>[];

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _placesSubscription;

  //listen to generate marker for each member
  StreamSubscription<MemberMarkerData>? _markerSubscription;

  // lấy thông tin hiện tại của group mà user chọn
  final SelectGroupCubit currentGroupCubit = getIt<SelectGroupCubit>();

  Future<void> initTrackingPlaces() async {
    _trackingListPlaces = [];
    //khi mà user chọn group => thì tiến hành lắng nghe realtime danh sách places trong group
    if (currentGroupCubit.state != null) {
      emit(const TrackingPlacesState.loading());
      _placesSubscription = _fireStoreClient
          .listenRealtimePlacesChanges(currentGroupCubit.state!.idGroup!)
          .listen((QuerySnapshot<Map<String, dynamic>> snapshot) {
        _processSnapshot(snapshot);
      });
    } else {
      emit(const TrackingPlacesState.initial());
    }
  }

  Future<void> _processSnapshot(
      QuerySnapshot<Map<String, dynamic>> snapshot) async {
    if (currentGroupCubit.state != null) {
      for (final change in snapshot.docChanges) {
        //when add new places
        if (change.type == DocumentChangeType.added) {
          StorePlace place = StorePlace.fromJson(change.doc.data()!);
          place = place.copyWith(idPlace: change.doc.id);
          _trackingListPlaces.add(place);
        }
        //when remove place
        if (change.type == DocumentChangeType.removed) {
          StorePlace place = StorePlace.fromJson(change.doc.data()!);
          place = place.copyWith(idCreator: change.doc.id);

          _trackingListPlaces
              .removeWhere((element) => element.idPlace == place.idPlace);
          debugPrint('list:$_trackingListPlaces');
        }
      }

      if (_trackingListPlaces.isEmpty) {
        emit(const TrackingPlacesState.success([]));
      } else {
        emit(TrackingPlacesState.success([..._trackingListPlaces]));
      }
    } else {
      emit(const TrackingPlacesState.initial());
    }
  }

  Future<void> generatePlacesMarker(
      StreamController<MemberMarkerData> streamController) async {
    _markerSubscription =
        streamController.stream.listen((MemberMarkerData event) async {
      if (currentGroupCubit.state != null) {
        try {
          final Uint8List? bytes =
              await CaptureWidgetHelp.widgetToBytes(event.repaintKey);
          final StorePlace place = _trackingListPlaces[event.index];
          _trackingListPlaces[event.index] = place.copyWith(marker: bytes);
          emit(TrackingPlacesState.success([..._trackingListPlaces]));
        } on Exception catch (e) {
          debugPrint(e.toString());
        }
      }
    });
  }

  void resetData() {
    emit(const TrackingPlacesState.initial());
    state.mapOrNull(
      initial: (value) {
        debugPrint('value$value');
      },
      success: (value) {},
    );
  }

  void disposeGroupSubscription() {
    _placesSubscription?.cancel();
  }

  void disposeMarkerSubscription() {
    if (_markerSubscription != null) {
      _markerSubscription?.cancel();
    }
  }

  void dispose() {
    _markerSubscription?.cancel();

    _placesSubscription?.cancel();
  }
}
