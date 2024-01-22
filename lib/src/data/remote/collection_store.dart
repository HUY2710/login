import 'package:cloud_firestore/cloud_firestore.dart';

class CollectionStoreConstant {
  CollectionStoreConstant._();
  static const String users = 'users';
  static const String groups = 'groups';
  static const String groupsOfUser = 'groupsOfUser'; // group in user collection
  static const String locations = 'locations';
}

class CollectionStore {
  CollectionStore._();

  static CollectionReference<Map<String, dynamic>> users =
      FirebaseFirestore.instance.collection(CollectionStoreConstant.users);

  static CollectionReference<Map<String, dynamic>> groups =
      FirebaseFirestore.instance.collection(CollectionStoreConstant.groups);

  static CollectionReference<Map<String, dynamic>> groupsOfUser =
      FirebaseFirestore.instance
          .collection(CollectionStoreConstant.groupsOfUser);

  static CollectionReference<Map<String, dynamic>> locations =
      FirebaseFirestore.instance.collection(CollectionStoreConstant.locations);
}
