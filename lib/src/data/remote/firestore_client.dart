import 'package:cloud_firestore/cloud_firestore.dart';

import '../../global/global.dart';
import '../models/store_group/store_group.dart';
import '../models/store_location/store_location.dart';
import '../models/store_user/store_user.dart';
import 'current_user_store.dart';
import 'group_manager.dart';
import 'location_manager.dart';

class FirestoreClient {
  FirestoreClient._privateConstructor();

  static final FirestoreClient instance = FirestoreClient._privateConstructor();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  //add new user
  Future<void> createUser(StoreUser user) async {
    await CurrentUserManager.createUser(user);
  }

  Future<StoreUser?> getUser(String userCode) async {
    return CurrentUserManager.getUser(userCode);
  }

  //manager group
  //add new user
  Future<void> createGroup(StoreGroup newGroup) async {
    await GroupsManager.createGroup(newGroup);
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

  //Add member to group
  Future<bool> addMemberToGroup(
      String idGroup, Map<String, dynamic> newMap) async {
    final result = await GroupsManager.addNewMemberToGroup(idGroup, newMap);
    return result;
  }

  //listen member group
  // Stream<QuerySnapshot<Map<String, dynamic>>> fetchTrackingMemberStream() {
  //   return GroupsManager.fetchTrackingMemberStream();
  // }

  ///[Location]
  Future<void> createNewLocation(StoreLocation newLocation) async {
    await LocationManager.createLocation(
        newLocation, Global.instance.user!.code);
  }

  Future<StoreLocation?> getLocation() {
    return LocationManager.getLocation();
  }

  Future<void> updateLocation(
    Map<String, dynamic> fields,
  ) async {
    await LocationManager.updateLocation(fields);
  }
}
