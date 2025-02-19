import 'package:cloud_firestore/cloud_firestore.dart';

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
    final CollectionReference collectionReference = CollectionStore.groups
        .doc(idGroup)
        .collection(CollectionStoreConstant.members);
    final QuerySnapshot querySnapshot = await collectionReference.get();
    final WriteBatch batch = FirebaseFirestore.instance.batch();
    // Lặp qua từng tài liệu và thêm thao tác xóa vào batch
    for (final doc in querySnapshot.docs) {
      batch.delete(doc.reference);
    }
    // Thực hiện batch write để xóa tất cả các tài liệu
    await batch.commit();
  }
}
