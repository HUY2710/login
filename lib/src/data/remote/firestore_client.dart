import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/store_group/store_group.dart';
import '../models/store_user/store_user.dart';
import 'current_user_store.dart';
import 'group_manager.dart';

class FirestoreConstant {
  static const String users = 'users';
}

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
}
