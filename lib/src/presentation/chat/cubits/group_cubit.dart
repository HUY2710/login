import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../data/models/store_group/store_group.dart';
import '../../../data/models/store_user/store_user.dart';
import '../../../data/remote/member_manager.dart';
import '../services/chat_service.dart';
import '../utils/util.dart';
import 'group_state.dart';

@singleton
class GroupCubit extends Cubit<GroupState> {
  GroupCubit() : super(const GroupState.initial());

  final ChatService chatService = ChatService.instance;

  final List<StoreGroup> myGroups = [];

  List<String> idsMyGroup = [];
  List<StoreUser> listStoreUser = [];

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _groupStream;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _userStream;

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
    emit(GroupState.success(myGroups));
  }

  Future<void> initStreamUser() async {
    _userStream = chatService.getUser2().listen((user) {
      if (user.docs.isNotEmpty) {
        final List<String> myListIdGroup = user.docs.map((e) => e.id).toList();

        idsMyGroup = myListIdGroup.map((e) => e).toList();
      }
    });
  }

  Future<void> initStreamGroupChat() async {
    myGroups.clear();
    _userStream = ChatService.instance.getUser2().listen((userSnapshot) async {
      if (userSnapshot.docs.isEmpty) {
        emit(const GroupState.initial());
      } else {
        //get all my group of user
        // lấy ra tất cả các id group trong myGroup collection user
        final List<String> myListIdGroup =
            userSnapshot.docs.map((e) => e.id).toList();
        idsMyGroup = myListIdGroup.map((e) => e).toList();

        //lấy thông tin group
        _groupStream = chatService
            .getMyGroupChat2(idsMyGroup)
            .listen((QuerySnapshot<Map<String, dynamic>> snapshot) async {
          //lấy ra id của user trong collection Group
          final listIdUser =
              await ChatService.instance.getListIdUserFromLastMessage();
          //lấy ra thông tin user từ các lasstMessage của group
          listStoreUser = await chatService.getUserFromListId(listIdUser);
          if (snapshot.docs.isNotEmpty) {
            for (final change in snapshot.docChanges) {
              if (change.type == DocumentChangeType.modified) {
                emit(const GroupState.loading());
                // lấy ra index của group đang bị thay đổi dưới local
                final index =
                    myGroups.indexWhere((e) => e.idGroup == change.doc.id);

                StoreGroup storeGroup = StoreGroup.fromJson(change.doc.data()!);
                // lấy ra thông tin user từ collection Users
                final storeUser = listStoreUser.firstWhere(
                  (storeUser) =>
                      storeUser.code == storeGroup.lastMessage!.senderId,
                );
                // kiểm tra thời gian đã xem từ local
                final seen = await Utils.getSeenMess(
                    change.doc.id, storeGroup.lastMessage!.sentAt);
                // gán vào group state
                storeGroup =
                    storeGroup.copyWith(storeUser: storeUser, seen: seen);
                if (index < myGroups.length) {
                  myGroups[index] = storeGroup;
                }
                emit(GroupState.success(myGroups));
              }
              if (change.type == DocumentChangeType.removed) {
                emit(const GroupState.loading());
                final index =
                    myGroups.indexWhere((e) => e.idGroup == change.doc.id);
                myGroups.removeAt(index);
                emit(GroupState.success(myGroups));
              }
              if (change.type == DocumentChangeType.added) {
                emit(const GroupState.loading());
                StoreGroup storeGroup = StoreGroup.fromJson(change.doc.data()!);
                final memberOfGroup =
                    await MemberManager.getListMemberOfGroup(change.doc.id);
                storeGroup = storeGroup.copyWith(
                    storeUser: listStoreUser.firstWhere(
                      (storeUser) =>
                          storeUser.code == storeGroup.lastMessage!.senderId,
                    ),
                    storeMembers: memberOfGroup);
                myGroups.add(storeGroup);
                emit(GroupState.success(myGroups));
              }
            }
            if (myGroups.isEmpty) {
              emit(const GroupState.initial());
            } else {
              emit(GroupState.success(myGroups));
            }
          } else {
            emit(const GroupState.initial());
          }
        });
      }
    });
  }
}
