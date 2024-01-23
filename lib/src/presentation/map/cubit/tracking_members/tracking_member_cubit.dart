import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../data/models/store_user/store_user.dart';
import '../../../../data/remote/firestore_client.dart';
import '../../models/member_maker_data.dart';

part 'tracking_member_cubit.freezed.dart';
part 'tracking_member_state.dart';

@injectable
class TrackingMemberCubit extends Cubit<TrackingMemberState> {
  TrackingMemberCubit() : super(const TrackingMemberState.initial());

  //object firebase
  final FirestoreClient _fireStoreClient = FirestoreClient.instance;
  //Danh sách các thành viên trong group
  final List<StoreUser> _trackingListMember = <StoreUser>[];

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _memberSubscription;

  //listen to generate marker for each member
  StreamSubscription<MemberMarkerData>? _markerSubscription;

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
