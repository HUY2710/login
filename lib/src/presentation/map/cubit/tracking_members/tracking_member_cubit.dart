import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../config/di/di.dart';
import '../../../../data/models/store_group/store_group.dart';
import '../../../../data/models/store_user/store_user.dart';
import '../../../../data/remote/firestore_client.dart';
import '../../models/member_maker_data.dart';
import '../select_group_cubit.dart';

part 'tracking_member_cubit.freezed.dart';
part 'tracking_member_state.dart';

@injectable
class TrackingMemberCubit extends Cubit<TrackingMemberState> {
  TrackingMemberCubit() : super(const TrackingMemberState.initial());

  //object firebase
  final FirestoreClient _fireStoreClient = FirestoreClient.instance;
  //Danh sách các thành viên trong group
  final List<StoreUser> _trackingListMember = <StoreUser>[];

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>?
      _groupSubscription;

  //listen to generate marker for each member
  StreamSubscription<MemberMarkerData>? _markerSubscription;

  // lấy thông tin hiện tại của group mà user chọn
  final SelectGroupCubit currentGroupCubit = getIt<SelectGroupCubit>();

  //stream lắng nghe members trong group có tự động thoát nhóm hay là bị xóa khỏi nhóm hay không
  StreamSubscription<StoreGroup>? _groupCurrentSubscription;

  Future<void> initTrackingMember() async {
    //hiện tại đang chọn 1 nhóm để xem
    if (currentGroupCubit.state != null) {
      emit(const TrackingMemberState.loading());
      _groupSubscription = _fireStoreClient
          .listenRealtimeToMembersChanges(currentGroupCubit.state!.idGroup)
          .listen((DocumentSnapshot<Map<String, dynamic>> event) {
        debugPrint('event:$event');
        final dataGroup = event.data()!;
        debugPrint('dataGroup:$dataGroup');
      });
    } else {
      //nếu user ko chọn nhóm nào thì ko xử lí gì cả
      emit(const TrackingMemberState.loading());
      emit(const TrackingMemberState.success([]));
    }
  }
  // Future<void> getListMembers() async {
  //   emit(const TrackingMemberState.loading());
  //   // await _initAndListenIsolate();

  //   _memberSubscription = _fireStoreClient.fetchTrackingMemberStream().listen(
  //     (snapshot) {
  //       for (final change in snapshot.docChanges) {
  //         if (change.type == DocumentChangeType.added) {
  //           final StoreUser member = StoreUser.fromJson(change.doc.data()!);
  //           // member = member.copyWith(subscription: _listenUserUpdate(friend));
  //           _trackingListMember.add(member);
  //         }
  //       }
  //       if (_trackingListMember.isEmpty) {
  //         emit(const TrackingMemberState.success([]));
  //       }
  //     },
  //   );
  // }
}
