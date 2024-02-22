import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../global/global.dart';
import '../../shared/utils/logger_utils.dart';
import '../models/store_group/store_group.dart';
import '../models/store_member/store_member.dart';
import 'collection_store.dart';
import 'member_manager.dart';
import 'places_manager.dart';

class GroupsManager {
  GroupsManager._();

  static Future<void> createGroup(StoreGroup newGroup) async {
    //create new document depend above code
    CollectionStore.groups
        .doc(newGroup.idGroup)
        .set(newGroup.toJson())
        .then((value) async {
      //if success => add Id document into Collection groups of User
      if (Global.instance.user != null) {
        await CollectionStore.users
            .doc(Global.instance.user!.code)
            .collection(CollectionStoreConstant.myGroups)
            .doc(newGroup.idGroup)
            .set({});
        await MemberManager.addNewMember(
          newGroup.idGroup!,
          StoreMember(
            idUser: Global.instance.user!.code,
            isAdmin: true,
          ),
        );
      }
    }).catchError((error) {
      LoggerUtils.logError('Failed to add group: $error');
    });
  }

  //kiểm tra xem mình còn trong group đó hay không ()
  static Future<DocumentSnapshot<Map<String, dynamic>>> isInGroup(
      String idGroup) async {
    return CollectionStore.users
        .doc(Global.instance.user!.code)
        .collection(CollectionStoreConstant.myGroups)
        .doc(idGroup)
        .get();
  }

  static Future<void> updateGroup({
    required String idGroup,
    required Map<String, dynamic> fields,
  }) async {
    await CollectionStore.groups
        .doc(idGroup)
        .update(fields)
        .catchError((error) {
      LoggerUtils.logError('Failed to update location: $error');
      throw Exception(error);
    });
  }

  //Xóa nhóm (chỉ admin mới có quyền xóa nhóm)
  static Future<bool> deleteGroup(StoreGroup group) async {
    //xóa collection members trước
    await MemberManager.deleteMemberCollection(group.idGroup!);
    await PlacesManager.removeAllPlaceOfGroup(group.idGroup!);
    //xóa group
    debugPrint('group:${group.idGroup}');
    final resultDeleteGroup = await CollectionStore.groups
        .doc(group.idGroup)
        .delete()
        .then((value) => true)
        .catchError((error) => false);
    return resultDeleteGroup;
    //xóa idGroup trong myGroups
  }

  //Admin xóa ra khỏi nhóm hoặc thành viên tự ý rời khỏi nhóm
  static Future<void> leaveGroup(
      {required String idGroup, required String idUser}) async {
    //xóa user ra khỏi nhóm
    await CollectionStore.groups
        .doc(idGroup)
        .collection(CollectionStoreConstant.members)
        .doc(idUser)
        .delete()
        .then((_) {
      LoggerUtils.logInfo('Leave group success');
    }).catchError((error) {
      LoggerUtils.logError('Failed to update location: $error');
      throw Exception(error);
    });
  }

  //xóa idGroup khỏi myGroup khi admin xóa thành viên hoặc user rời khỏi nhóm
  static Future<void> removeIdGroupOfMyGroup(
      {required String idGroup, required String idUser}) async {
    await CollectionStore.users
        .doc(idUser)
        .collection(CollectionStoreConstant.myGroups)
        .doc(idGroup)
        .delete()
        .then((_) {
      LoggerUtils.logInfo('remove idGroup of MyGroup success');
    }).catchError((error) {
      LoggerUtils.logError('Failed to remove idGroup of MyGroup: $error');
      throw Exception(error);
    });
  }

  //xóa id của group đó ra khỏi list group của
  static Future<void> deleteIdGroupOfMyGroup(StoreGroup group) async {
    if (group.storeMembers != null &&
        group.storeMembers!.isNotEmpty &&
        group.idGroup != null) {
      group.storeMembers?.map((StoreMember storeMember) async {
        await CollectionStore.users
            .doc(storeMember.idUser)
            .collection(CollectionStoreConstant.myGroups)
            .doc(group.idGroup)
            .delete()
            .then((value) => true)
            .catchError((error) => false);
      });
      //xóa khỏi mygroup của mình
      await CollectionStore.users
          .doc(Global.instance.user!.code)
          .collection(CollectionStoreConstant.myGroups)
          .doc(group.idGroup)
          .delete()
          .then((value) => true)
          .catchError((error) => false);
    }
  }

  //snapshot data for each member in group
  static Stream<QuerySnapshot<Map<String, dynamic>>> fetchTrackingMemberStream(
      List<String> memberCode) {
    //get info current group
    final snapshot =
        CollectionStore.users.where('code', whereIn: memberCode).snapshots();

    return snapshot;
  }

  static Future<StoreGroup?> getDetailGroup(
    String idGroup,
  ) async {
    final DocumentSnapshot<Map<String, dynamic>> doc =
        await CollectionStore.groups.doc(idGroup).get();
    if (doc.data() == null) {
      return null;
    }

    final String documentId = doc.id;
    final StoreGroup group = StoreGroup.fromJson(doc.data()!);
    final memberOfGroup = await MemberManager.getListMemberOfGroup(documentId);
    return group.copyWith(idGroup: documentId, storeMembers: memberOfGroup);
  }

  static Future<List<StoreGroup>?> getMyListGroup() async {
    final String code = Global.instance.user!.code;

    //lấy ra toàn bộ id các group của mình
    final snapShotGroups = await CollectionStore.users
        .doc(code)
        .collection(CollectionStoreConstant.myGroups)
        .get();
    if (snapShotGroups.docs.isNotEmpty) {
      final List<String> myListIdGroup =
          snapShotGroups.docs.map((e) => e.id).toList();
      debugPrint('myListIdGroup:$myListIdGroup');

      //SAU KHI LẤY ĐƯỢC TẤT CẢ ID GROUP MÀ MÌNH JOIN
      //GET INFO GROUP
      final resultGroups = await allMyGroups(myListIdGroup);
      return resultGroups;
    }

    return [];
  }

  static Future<List<StoreGroup>?> allMyGroups(List<String> myIdsGroup) async {
    final List<String> idsCondition =
        myIdsGroup.map((idGroup) => idGroup).toList();
    final snapshot = await CollectionStore.groups
        .where(FieldPath.documentId, whereIn: idsCondition)
        .get();

    final List<StoreGroup> infoListGroup =
        await Future.wait(snapshot.docs.map((e) async {
      final String documentId = e.id;
      final group = StoreGroup.fromJson(e.data());
      final memberOfGroup =
          await MemberManager.getListMemberOfGroup(documentId);
      return group.copyWith(idGroup: documentId, storeMembers: memberOfGroup);
    }).toList());

    debugPrint('info groups:$infoListGroup');
    return infoListGroup;
  }

  //kiểm tra xem có group nào tồn tại với mã code đó hay không
  static Future<StoreGroup?> isExistGroup(String passCode) async {
    final result = await CollectionStore.groups
        .where('passCode', isEqualTo: passCode)
        .limit(1)
        .get();
    if (result.docs.isNotEmpty) {
      // Lấy document đầu tiên từ QuerySnapshot
      final QueryDocumentSnapshot<Map<String, dynamic>> document =
          result.docs.first;

      // Lấy dữ liệu từ Firestore và chuyển đổi thành đối tượng StoreGroup
      StoreGroup storeGroup = StoreGroup.fromJson(document.data());
      // Lấy documentId
      final String documentId = document.id;

      //set id cho local
      storeGroup = storeGroup.copyWith(idGroup: documentId);
      return storeGroup;
    }
    return null;
  }

  //Add idUser into members of group
  static Future<bool> addNewMemberToGroup(
      String idGroup, StoreMember newMember) async {
    final resultAddMember = await CollectionStore.groups
        .doc(idGroup)
        .collection(CollectionStoreConstant.members)
        .doc(newMember.idUser)
        .set(newMember.toJson())
        .then((value) {
      final status = addToMyGroup(idGroup);
      return status;
    }).catchError((error) {
      return false;
    });
    return resultAddMember;
  }

  //sau khi join thành công thì add idGroup đó vào myGroups
  static Future<bool> addToMyGroup(String idGroup) async {
    final status = await CollectionStore.users
        .doc(Global.instance.user!.code)
        .collection(CollectionStoreConstant.myGroups)
        .doc(idGroup)
        .set({})
        .then((value) => true)
        .catchError((error) => false);
    return status;
  }

  // Lắng nghe sự thay đổi trong danh sách thành viên của nhóm để theo dõi sự kiện thoát nhóm hoặc xóa thành viên.
  static Stream<QuerySnapshot<Map<String, dynamic>>>
      listenToGroupMembersChanges(String groupId) {
    return CollectionStore.groups
        .doc(groupId)
        .collection(CollectionStoreConstant.members)
        .snapshots();
  }

  //lấy ra toàn bộ id các group của mình
  static Future<List<String>?> getIdMyListGroup() async {
    if (Global.instance.user?.code != '') {
      final String code = Global.instance.user!.code;
      final snapShotGroups = await CollectionStore.users
          .doc(code)
          .collection(CollectionStoreConstant.myGroups)
          .get();
      if (snapShotGroups.docs.isNotEmpty) {
        final List<String> myListIdGroup =
            snapShotGroups.docs.map((e) => e.id).toList();
        return myListIdGroup;
      }
      return [];
    }
    return null;
  }

  //lắng nghe realtime myIdGroups collection
  //xem mình join hay thoát, bị xóa ra khỏi group nào
  static Stream<QuerySnapshot<Map<String, dynamic>>> listenMyIdGroups() {
    return CollectionStore.users
        .doc(Global.instance.user!.code)
        .collection(CollectionStoreConstant.myGroups)
        .snapshots();
  }

  static Future<void> updateNotify(String idGroup, bool onNotify) async {
    await CollectionStore.groups
        .doc(idGroup)
        .update({'notify': onNotify}).catchError((error) {
      throw Exception(error);
    });
  }

  //mỗi member sẽ tự quản lí thông báo của mình
  //muốn nhận hay không nhận thông báo từ group đó
  static Future<void> updateNotifyEachMember(
      String idGroup, bool onNotify) async {
    await CollectionStore.groups
        .doc(idGroup)
        .collection(CollectionStoreConstant.members)
        .doc(Global.instance.user!.code)
        .update({'onNotify': onNotify}).catchError((error) {
      throw Exception(error);
    });
  }
}
