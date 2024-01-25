import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../config/di/di.dart';
import '../../global/global.dart';
import '../../presentation/map/cubit/select_group_cubit.dart';
import '../../shared/extension/int_extension.dart';
import '../../shared/utils/logger_utils.dart';
import '../models/store_group/store_group.dart';
import 'collection_store.dart';

class GroupsManager {
  GroupsManager._();

  static Future<void> createGroup(StoreGroup newGroup) async {
    final generateIdGroup = 20.randomString(); //Id of document group

    //create new document depend above code
    CollectionStore.groups
        .doc(generateIdGroup)
        .set(newGroup.copyWith().toJson())
        .then((value) {
      //if success => add Id document into Collection groups of User
      if (Global.instance.user != null) {
        CollectionStore.users
            .doc(Global.instance.user!.code)
            .collection(CollectionStoreConstant.myGroups)
            .doc(generateIdGroup)
            .set(
              MyIdGroup(idGroup: generateIdGroup).toJson(),
            );
      }
    }).catchError((error) {
      LoggerUtils.logError('Failed to add group: $error');
    });
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
    final StoreGroup group = StoreGroup.fromJson(doc.data()!);
    LoggerUtils.logInfo('Fetch User: ${Global.instance.user}');
    return group;
  }

  static Future<List<StoreGroup>?> getMyListGroup() async {
    final String code = Global.instance.user!.code;

    //lấy ra toàn bộ id các group của mình
    final snapShotGroups = await CollectionStore.users
        .doc(code)
        .collection(CollectionStoreConstant.myGroups)
        .get();
    if (snapShotGroups.docs.isNotEmpty) {
      final List<MyIdGroup> myListIdGroup =
          snapShotGroups.docs.map((e) => MyIdGroup.fromJson(e.data())).toList();
      debugPrint('myListIdGroup:$myListIdGroup');

      //SAU KHI LẤY ĐƯỢC TẤT CẢ ID GROUP MÀ MÌNH JOIN
      //GET INFO GROUP
      final resultGroups = await allMyGroups(myListIdGroup);
      return resultGroups;
    }

    return [];
  }

  static Future<List<StoreGroup>?> allMyGroups(
      List<MyIdGroup> myIdsGroup) async {
    final List<String> idsCondition = myIdsGroup.map((e) => e.idGroup).toList();
    final snapshot = await CollectionStore.groups
        .where(FieldPath.documentId, whereIn: idsCondition)
        .get();
    final List<StoreGroup> infoListGroup = snapshot.docs.map((e) {
      final String documentId = e.id;
      final group = StoreGroup.fromJson(e.data());
      return group.copyWith(idGroup: documentId);
    }).toList();
    debugPrint('info groups:$infoListGroup');
    return infoListGroup;
  }

  //kiểm tra xem có group nào tồn tại với mã code đó hay không
  static Future<StoreGroup?> isExistGroup(String passCode) async {
    final result = await CollectionStore.groups
        .where('code', isEqualTo: passCode)
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
      String idGroup, Map<String, dynamic> newMap) async {
    final resultAddMember =
        await CollectionStore.groups.doc(idGroup).update(newMap).then((value) {
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
        .set(
          MyIdGroup(idGroup: idGroup).toJson(),
        )
        .then((value) => true)
        .catchError((error) => false);
    return status;
  }
}
