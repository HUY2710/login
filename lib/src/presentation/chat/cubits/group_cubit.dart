import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../data/models/store_group/store_group.dart';
import '../../../data/models/store_message/store_message.dart';
import '../../../data/models/store_user/store_user.dart';
import '../../../data/remote/firestore_client.dart';
import '../../../gen/assets.gen.dart';
import '../../../global/global.dart';
import '../services/chat_service.dart';
import '../utils/util.dart';
import 'group_state.dart';

@singleton
class GroupCubit extends Cubit<GroupState> {
  GroupCubit() : super(const GroupState.initial());

  final ChatService chatService = ChatService.instance;

  final List<StoreGroup> myGroups = [];

  Future<void> sendMessage(
      {required String content,
      required String idGroup,
      required String groupName}) async {
    await ChatService.instance.sendMessage(
      content: content,
      idGroup: idGroup,
      groupName: groupName,
    );
    emit(GroupState.success(myGroups));
  }

  void updateLastSeen(String idGroup) {
    emit(const GroupState.loading());
    final index = myGroups.indexWhere((e) => e.idGroup == idGroup);
    StoreGroup temp = myGroups[index];
    temp = myGroups[index].copyWith(seen: false);
    myGroups[index] = temp;
    sortGroup();
    emit(GroupState.success(myGroups));
  }

  Future<void> initStreamGroupChat() async {
    myGroups.clear();
    chatService.getUser2().listen((groupOfUser) async {
      if (groupOfUser.docs.isEmpty) {
        for (final group in myGroups) {
          await group.groupSubscription?.cancel();
        }
        myGroups.clear();
        emit(const GroupState.initial());
      } else {
        // lắng nghe mygroup trong collection user
        for (final groupChange in groupOfUser.docChanges) {
          switch (groupChange.type) {
            case DocumentChangeType.added:
              StoreGroup? storeGroup = await FirestoreClient.instance
                  .getDetailGroup(groupChange.doc.id);
              if (storeGroup != null) {
                storeGroup = storeGroup.copyWith(
                    groupSubscription: _listenGroupUpdate(storeGroup));
                myGroups.add(storeGroup);
              }
              break;
            case DocumentChangeType.removed:
              final StoreGroup? storeGroup = await FirestoreClient.instance
                  .getDetailGroup(groupChange.doc.id);
              final index = myGroups
                  .indexWhere((group) => group.idGroup == storeGroup!.idGroup);
              await myGroups[index].groupSubscription?.cancel();
              myGroups
                  .removeWhere((group) => group.idGroup == storeGroup!.idGroup);
              break;
            default:
          }
        }
        if (myGroups.isEmpty) {
          emit(GroupState.initial());
        } else {
          sortGroup();
          emit(GroupState.success([...myGroups]));
        }
      }
    });
  }

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>?
      _listenGroupUpdate(StoreGroup storeGroup) {
    final subscription = chatService
        .streamGroupChat(storeGroup.idGroup!)
        .listen((snapshot) async {
      if (snapshot.exists) {
        final StoreGroup storeGroupTemp = StoreGroup.fromJson(snapshot.data()!);
        //lấy ra thông tin user từ tin nhắn cuối cùng trong collection group
        StoreUser? storeUser = await FirestoreClient.instance
            .getUser(storeGroupTemp.lastMessage!.senderId);
        // storeUser mà null có nghĩa là tài khoản đã bị xóa
        storeUser ??= StoreUser(
            code: '',
            avatarUrl: Assets.images.avatars.male.avatar1.path,
            userName: 'Deleted Account',
            batteryLevel: 100);
        bool seen = false;
        // người dùng check in thì không kiểm tra đã gửi hay chưa
        if (storeGroupTemp.lastMessage!.senderId == Global.instance.userCode &&
            storeGroupTemp.lastMessage!.messageType == MessageType.checkIn) {
          seen = storeGroup.seen ?? false;
        } else {
          seen = await Utils.getSeenMess(
              storeGroup.idGroup!, storeGroupTemp.lastMessage!.sentAt);
        }
        // cập nhật store user, seen và last message cho group
        storeGroup = storeGroup.copyWith(
          storeUser: storeUser,
          seen: seen,
          lastMessage: storeGroupTemp.lastMessage,
          groupName: storeGroupTemp.groupName,
          avatarGroup: storeGroupTemp.avatarGroup,
        );

        //lấy ra index của group thay đổi dưới local
        final index = myGroups.indexWhere((e) => e.idGroup == snapshot.id);
        if (index < myGroups.length) {
          //cập nhật list group
          emit(const GroupState.loading());
          myGroups[index] = storeGroup;
          // sắp xếp theo group có tin nhắn cuối cùng muộn nhất
          sortGroup();
          emit(GroupState.success([...myGroups]));
        }
      }
      // lấy ra group thay đổi
    });

    return subscription;
  }

  void sortGroup() {
    myGroups
        .sort((a, b) => b.lastMessage!.sentAt.compareTo(a.lastMessage!.sentAt));
  }
}
