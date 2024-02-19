import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../config/di/di.dart';
import '../../../../data/models/store_location/store_location.dart';
import '../../../../data/models/store_member/store_member.dart';
import '../../../../data/models/store_user/store_user.dart';
import '../../../../data/remote/firestore_client.dart';
import '../../../../global/global.dart';
import '../../../../shared/helpers/capture_widget_helper.dart';
import '../../models/member_maker_data.dart';
import '../select_group_cubit.dart';
import 'isolate_tracking_location/entry_point.dart';
import 'isolate_tracking_location/isolate_tracking_response.dart';

part 'tracking_member_cubit.freezed.dart';
part 'tracking_member_state.dart';

@injectable
class TrackingMemberCubit extends Cubit<TrackingMemberState> {
  TrackingMemberCubit() : super(const TrackingMemberState.initial());

  final FirestoreClient _fireStoreClient = FirestoreClient.instance;

  //Danh sách các thành viên trong group
  List<StoreUser> _trackingListMember = <StoreUser>[];

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _groupSubscription;

  //listen to generate marker for each member
  StreamSubscription<MemberMarkerData>? _markerSubscription;

  // lấy thông tin hiện tại của group mà user chọn
  final SelectGroupCubit currentGroupCubit = getIt<SelectGroupCubit>();

  //sử dụng isolate
  Isolate? _isolate;
  // Tạo một ReceivePort để nhận kết quả từ isolate
  final ReceivePort _receivePort = ReceivePort();
  SendPort? _isolateSendPort;

  //khởi tạo và lắng nghe các sự kiện của isolate
  Future<void> _initAndListenIsolate() async {
    final Completer<void> completer = Completer();
    _isolate = await Isolate.spawn(entryPoint, _receivePort.sendPort);

    //lắng nghe kết quả từ isolate
    _receivePort.listen((message) {
      if (message is SendPort) {
        _isolateSendPort = message;
        completer.complete();
      } else if (message is IsolateTrackingResponse) {
        emit(TrackingMemberState.success([..._trackingListMember]));
      }
    });
    return completer.future;
  }

  Future<void> initTrackingMember() async {
    _trackingListMember = [];
    debugPrint('_trackingListMember:$_trackingListMember');
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
      emit(const TrackingMemberState.initial());
    }
  }

  Future<void> _processSnapshot(
      QuerySnapshot<Map<String, dynamic>> snapshot) async {
    if (currentGroupCubit.state != null) {
      for (final change in snapshot.docChanges) {
        //lắng nghe khi có member join group
        if (change.type == DocumentChangeType.added) {
          StoreMember member = StoreMember.fromJson(change.doc.data()!);
          member = member.copyWith(idUser: change.doc.id);

          StoreUser? infoUser = await _fireStoreClient.getUser(member.idUser!);
          //sau khi lấy được thông tin user thì tiến hành query đến location của user đó

          // Thực hiện các xử lý khác với infoUser...
          if (infoUser != null && infoUser.code != Global.instance.user?.code) {
            //lấy vị trí cuối cùng của user
            infoUser = infoUser.copyWith(
                location: await _fireStoreClient.getUserLocation(infoUser.code),
                subscriptionLocation: _listenLocationUserUpdate(infoUser));
            _trackingListMember.add(infoUser);
          } else {
            debugPrint('${infoUser?.code != Global.instance.user?.code}');
            debugPrint('idMember:${infoUser?.code}');
            debugPrint('your code:${Global.instance.user?.code}');
          }
        }
        //lắng nghe khi có member rời hoặc bị xóa khỏi group
        if (change.type == DocumentChangeType.removed) {
          StoreMember member = StoreMember.fromJson(change.doc.data()!);
          member = member.copyWith(idUser: change.doc.id);
          final StoreUser? infoUser =
              await _fireStoreClient.getUser(member.idUser!);
          //sau khi lấy được thông tin user thì tiến hành query đến location của user đó

          //nếu id bằng với của mình thì có nghĩa là mình bị admin xóa ra khỏi nhóm
          //thì lúc này reset lại data group và không còn tracking ai
          if (infoUser != null && infoUser.code == Global.instance.user?.code) {
            _trackingListMember = [];
            getIt<SelectGroupCubit>().update(null); //reset group
            debugPrint('list:$_trackingListMember');
          } else {
            // xóa user đó ra khỏi list tracking...
            if (infoUser != null &&
                infoUser.code != Global.instance.user?.code) {
              _trackingListMember
                  .removeWhere((element) => element.code == infoUser.code);
              debugPrint('list:$_trackingListMember');
            }
          }
        }
      }
      if (_trackingListMember.isEmpty) {
        emit(const TrackingMemberState.success([]));
      } else {
        emit(TrackingMemberState.success([..._trackingListMember]));
      }
    } else {
      emit(const TrackingMemberState.initial());
    }
  }

  Future<void> generateUserMarker(
      StreamController<MemberMarkerData> streamController) async {
    _markerSubscription =
        streamController.stream.listen((MemberMarkerData event) async {
      if (currentGroupCubit.state != null) {
        try {
          final Uint8List? bytes =
              await CaptureWidgetHelp.widgetToBytes(event.repaintKey);
          final StoreUser user = _trackingListMember[event.index];
          _trackingListMember[event.index] = user.copyWith(marker: bytes);
          emit(TrackingMemberState.success([..._trackingListMember]));
        } on Exception catch (e) {
          debugPrint(e.toString());
        }
      }
    });
  }

  //lắng nghe xem vị trí của user có thay đổi hay không
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>?>>?
      _listenLocationUserUpdate(StoreUser user) {
    final subscription = _fireStoreClient
        .listenLocationUser(user.code)
        .listen((DocumentSnapshot<Map<String, dynamic>?> docSnap) {
      if (docSnap.data() != null && docSnap.exists) {
        final StoreLocation location = StoreLocation.fromJson(docSnap.data()!);
        user = user.copyWith(location: location);
      }
    });
    return subscription;
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

  void resetData() {
    emit(const TrackingMemberState.initial());
    state.mapOrNull(
      initial: (value) {
        debugPrint('value$value');
      },
      success: (value) {
        debugPrint('success:${value.members}');
      },
    );
  }

  void disposeGroupSubscription() {
    _groupSubscription?.cancel();
  }

  void disposeMarkerSubscription() {
    if (_markerSubscription != null) {
      _markerSubscription?.cancel();
    }
  }

  void dispose() {
    _markerSubscription?.cancel();
    for (final StoreUser element in _trackingListMember) {
      element.subscriptionLocation?.cancel();
    }
    _receivePort.close();
    _isolate?.kill();
    _groupSubscription?.cancel();
  }
}
