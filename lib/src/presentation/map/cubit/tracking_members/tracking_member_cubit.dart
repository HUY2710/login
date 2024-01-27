import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../config/di/di.dart';
import '../../../../data/models/store_group/store_group.dart';
import '../../../../data/models/store_member/store_member.dart';
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

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _groupSubscription;

  //listen to generate marker for each member
  StreamSubscription<MemberMarkerData>? _markerSubscription;

  // lấy thông tin hiện tại của group mà user chọn
  final SelectGroupCubit currentGroupCubit = getIt<SelectGroupCubit>();

  Future<void> initTrackingMember() async {
    //khi mà user chọn group => thì tiến hành lắng nghe realtime danh sách member trong group
    if (currentGroupCubit.state != null) {
      emit(const TrackingMemberState.loading());
      _groupSubscription = _fireStoreClient
          .listenRealtimeToMembersChanges(currentGroupCubit.state!.idGroup!)
          .listen((QuerySnapshot<Map<String, dynamic>> snapshot) {
        _processSnapshot(snapshot);
      });
    } else {
      //nếu user ko chọn nhóm nào thì ko xử lí gì cả
      emit(const TrackingMemberState.loading());
      emit(const TrackingMemberState.success([]));
    }
  }

  Future<void> _processSnapshot(
      QuerySnapshot<Map<String, dynamic>> snapshot) async {
    for (final change in snapshot.docChanges) {
      if (change.type == DocumentChangeType.added) {
        StoreMember member = StoreMember.fromJson(change.doc.data()!);
        member = member.copyWith(idUser: change.doc.id);

        final StoreUser? infoUser =
            await _fireStoreClient.getUser(member.idUser!);
        //sau khi lấy được thông tin user thì tiến hành query đến location của user đó

        // Thực hiện các xử lý khác với infoUser...
      }
    }

    if (_trackingListMember.isEmpty) {
      emit(const TrackingMemberState.success([]));
    }
  }

  //lắng nghe xem vị trí của user có thay đổi hay không
  // StreamSubscription<DocumentSnapshot<Map<String, dynamic>?>>?
  //     _listenLocationUserUpdate(String idUser) {
  //   final subscription = friend.ref
  //       ?.snapshots()
  //       .listen((DocumentSnapshot<Map<String, dynamic>?> event) {
  //     final StoreUser user = StoreUser.fromJson(event.data()!);
  //     friend = friend.copyWith(user: user);

  //     _isolateSendPort?.send(friend);
  //   });
  //   return subscription;
  // }

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
