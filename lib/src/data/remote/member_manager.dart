import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../shared/utils/logger_utils.dart';
import '../models/store_member/store_member.dart';
import 'collection_store.dart';

class MemberManager {
  MemberManager._();

  static Future<void> addNewMember(
      String idGroup, StoreMember newMember) async {
    CollectionStore.groups
        .doc(idGroup)
        .collection(CollectionStoreConstant.members)
        .doc(newMember.idUser)
        .set(newMember.toJson())
        .then((value) {
      return value;
    }).catchError((error) {
      LoggerUtils.logError('Failed to add group: $error');
    });
  }

  //can update lai
  static Future<List<StoreMember>?> getListMemberOfGroup(String idGroup) async {
    final snapShot = await CollectionStore.groups
        .doc(idGroup)
        .collection(CollectionStoreConstant.members)
        .get();
    final data = snapShot.docs;

    final List<StoreMember> listMember =
        data.map((QueryDocumentSnapshot<Map<String, dynamic>> e) {
      StoreMember member = StoreMember.fromJson(e.data());
      member = member.copyWith(idUser: e.id);
      return member;
    }).toList();

    return listMember;
  }

  //delete member group
  static Future<void> deleteMemberDocument(
      String documentIdMemberCollection) async {
    try {
      // Xóa member của group
      await CollectionStore.members.doc(documentIdMemberCollection).delete();
    } catch (error) {
      // Nếu có lỗi
      throw Exception('Failed to delete member document: $error');
    }
  }

  static Future<void> deleteMemberCollection(String idGroup) async {
    // Lấy reference của collection "member" trong document user
    final CollectionReference memberCollectionRef = CollectionStore.groups
        .doc(idGroup)
        .collection(CollectionStoreConstant.members);

    // Lấy danh sách document trong collection "member"
    final QuerySnapshot memberSnapshot = await memberCollectionRef.get();

    // Xóa từng document trong collection
    for (final QueryDocumentSnapshot memberDoc in memberSnapshot.docs) {
      await memberDoc.reference.delete();
    }

    // Cuối cùng, xóa collection "member" khỏi document user
    await memberCollectionRef.parent?.delete();
  }
}
