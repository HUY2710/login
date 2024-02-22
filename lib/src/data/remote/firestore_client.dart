import 'package:cloud_firestore/cloud_firestore.dart';

import '../../global/global.dart';
import '../models/store_group/store_group.dart';
import '../models/store_history_place/store_history_place.dart';
import '../models/store_location/store_location.dart';
import '../models/store_member/store_member.dart';
import '../models/store_place/store_place.dart';
import '../models/store_user/store_user.dart';
import 'collection_store.dart';
import 'user_manager.dart';
import 'group_manager.dart';
import 'history_place_manager.dart';
import 'location_manager.dart';
import 'member_manager.dart';
import 'places_manager.dart';

class FirestoreClient {
  FirestoreClient._privateConstructor();

  static final FirestoreClient instance = FirestoreClient._privateConstructor();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  //add new user
  Future<void> createUser(StoreUser user) async {
    await CurrentUserManager.createUser(user);
  }

  Future<void> updateUser(
    Map<String, dynamic> fields,
  ) async {
    await CurrentUserManager.updateUser(Global.instance.user!.code, fields);
  }

  Future<StoreUser?> getUser(String userCode) async {
    return CurrentUserManager.getUser(userCode);
  }

  //lắng nghe user thay đổi => acitivity, online....
  Stream<DocumentSnapshot<Map<String, dynamic>>> listenStreamUser(
      String? idUser) {
    return CurrentUserManager.streamUser(idUser);
  }

  //manager group
  //lắng nghe sự thay đổi của tất cả groups của mình (groups mình tạo, groups mình join)
  Stream<QuerySnapshot<Map<String, dynamic>>> listenMyGroups() {
    return GroupsManager.listenMyIdGroups();
  }

  Future<void> createGroup(StoreGroup newGroup) async {
    await GroupsManager.createGroup(newGroup);
  }

  //update notify group
  Future<void> updateNotifyGroup(
      {required String idGroup, required bool onNotify}) async {
    GroupsManager.updateNotify(idGroup, onNotify);
  }

  Future<void> updateNotifyGroupEachMember(
      {required String idGroup, required bool onNotify}) async {
    GroupsManager.updateNotifyEachMember(idGroup, onNotify);
  }

  //get detail group
  Future<StoreGroup?> getDetailGroup(String idGroup) async {
    final group = await GroupsManager.getDetailGroup(idGroup);
    return group;
  }

  //kiểm tra xem mình còn trong group đó hay không
  Future<bool> isInGroup(String idGroup) async {
    try {
      final result = await GroupsManager.isInGroup(idGroup);
      if (result.exists && result.data() != null) {
        return true;
      }
      return false;
    } catch (error) {
      throw Exception(error);
    }
  }

  //update group
  Future<void> updateGroup({
    required String idGroup,
    required Map<String, dynamic> mapFields,
  }) async {
    await GroupsManager.updateGroup(idGroup: idGroup, fields: mapFields);
  }

  //get my list group
  Future<List<StoreGroup>?> getMyGroups() async {
    final result = await GroupsManager.getMyListGroup();
    return result;
  }

  //kiểm tra sự tồn tại của group
  Future<StoreGroup?> isExistGroup(String passCode) async {
    final group = await GroupsManager.isExistGroup(passCode);
    return group;
  }

  //lay danh sach cac thanh vien trong group
  Future<List<StoreMember>?> getListMemberOfGroup(String idGroup) async {
    final result = await MemberManager.getListMemberOfGroup(idGroup);
    return result;
  }

  //kiểm tra xem bạn đã là thành viên của group chưa
  Future<bool> isExistMemberGroup(String idGroup) async {
    final docRef = firestore
        .collection(CollectionStoreConstant.groups)
        .doc(idGroup)
        .collection(CollectionStoreConstant.members)
        .doc(Global.instance.user!.code);

    final docSnapshot = await docRef.get();

    // Kiểm tra xem tài liệu có tồn tại hay không
    return docSnapshot.exists;
  }

  //Add member to group
  Future<bool> addMemberToGroup(String idGroup, StoreMember newMember) async {
    final result = await GroupsManager.addNewMemberToGroup(idGroup, newMember);
    return result;
  }

  //xóa group
  Future<bool> deleteGroup(StoreGroup group) async {
    //đầu tiên là xóa group
    final result = await GroupsManager.deleteGroup(group);
    //tiếp theo là xóa idGroup trong myGroup
    await deleteIdGroupInMyGroup(group);
    //tiếp theo là xóa toàn bộ member
    await MemberManager.deleteMemberDocument(group.idGroup!);
    return result;
  }

  //xóa user ra khỏi nhóm hoặc user tự thoát nhóm
  Future<void> leaveGroup(String idGroup, String idUser) async {
    await GroupsManager.leaveGroup(idGroup: idGroup, idUser: idUser);
    await GroupsManager.removeIdGroupOfMyGroup(
        idGroup: idGroup, idUser: idUser);
    return;
  }

  Future<void> deleteIdGroupInMyGroup(StoreGroup group) async {
    await GroupsManager.deleteIdGroupOfMyGroup(group);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> listenRealtimeToMembersChanges(
      String idGroup) {
    return GroupsManager.listenToGroupMembersChanges(idGroup);
  }

  //lấy toàn bộ id group mà mình join
  Future<List<String>?> listIdGroup() async {
    return GroupsManager.getIdMyListGroup();
  }

  ///[Location]
  Future<void> createNewLocation(StoreLocation newLocation) async {
    await LocationManager.createLocation(
        newLocation, Global.instance.user!.code);
  }

  Future<StoreLocation?> getLocation() {
    return LocationManager.getLocation();
  }

  Future<StoreLocation?> getUserLocation(String idUser) {
    return LocationManager.getUserLocation(idUser);
  }

  Future<void> updateLocation(
    Map<String, dynamic> fields,
  ) async {
    await LocationManager.updateLocation(fields);
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> listenLocationUser(
      String idUser) {
    return LocationManager.listenLocationUserChange(idUser);
  }

  //manager places
  Future<void> createPlace(String idGroup, StorePlace newPlace) async {
    await PlacesManager.createPlace(idGroup: idGroup, place: newPlace);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> listenRealtimePlacesChanges(
      String idGroup) {
    return PlacesManager.listenRealtimePlacesChanges(idGroup);
  }

  Future<void> removePlace(String idGroup, String idPlace) async {
    await PlacesManager.removePlace(idGroup: idGroup, idPlace: idPlace);
  }

  //lấy toàn bộ place trong group
  Future<List<StorePlace>?> listPlaces(String idGroup) async {
    return PlacesManager.getListStorePlace(idGroup);
  }

  Future<void> updatePlace(
      String idGroup, String idPlace, Map<String, dynamic> fields) async {
    await PlacesManager.updatePlace(idGroup, idPlace, fields);
  }

  //add history place
  Future<void> createHistoryPlace(
      {required String idGroup,
      required StoreHistoryPlace historyPlace}) async {
    await HistoryPlacesManager.createHistoryPlace(
        idGroup: idGroup, historyPlace: historyPlace);
  }

  Future<StoreHistoryPlace?> getDetailHistoryPlace(
      {required String idGroup, required String idPlace}) async {
    return HistoryPlacesManager.getDetailHistoryPlace(
        idGroup: idGroup, idPlace: idPlace);
  }

  Future<void> updateHistoryPlace(
      {required String idGroup,
      required StoreHistoryPlace historyPlace}) async {
    await HistoryPlacesManager.updateHistoryPlace(
        idGroup: idGroup, historyPlace: historyPlace);
  }

  //get history places
  Future<List<StoreHistoryPlace>?> getListHistoryPlace(
      {required String idGroup, required String idUser}) async {
    return HistoryPlacesManager.getListHistoryPlace(
        idGroup: idGroup, idUser: idUser);
  }
}
