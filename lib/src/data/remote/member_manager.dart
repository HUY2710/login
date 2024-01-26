import 'package:flutter/material.dart';

import '../../shared/utils/logger_utils.dart';
import '../models/store_member/store_member.dart';
import 'collection_store.dart';

class MemberManager {
  MemberManager._();

  static Future<void> addNewMember(StoreMember newMember) async {
    CollectionStore.members
        .doc(newMember.idGroup) //idGroup để nhận biết member của group nào
        .set(newMember.toJson())
        .then((value) {
      return value;
    }).catchError((error) {
      LoggerUtils.logError('Failed to add group: $error');
    });
  }

  static Future<StoreMember?> getListMember(String idGroup) async {
    final snapShot = await CollectionStore.members
        .doc(idGroup) //idGroup để nhận biết member của group nào
        .get();
    final data = snapShot.data();
    if (data != null) {
      StoreMember members = StoreMember.fromJson(data);
      members = members.copyWith(idGroup: idGroup);

      return members;
    }
    return null;
  }

  //delete group
  static Future<void> deleteMemberDocument(
      String documentIdMemberCollection) async {
    try {
      // Xóa list member của group
      await CollectionStore.members.doc(documentIdMemberCollection).delete();
    } catch (error) {
      // Nếu có lỗi
      throw Exception('Failed to delete member document: $error');
    }
  }
}
