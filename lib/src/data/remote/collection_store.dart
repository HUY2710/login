import 'package:cloud_firestore/cloud_firestore.dart';

class CollectionStoreConstant {
  CollectionStoreConstant._();
  static const String users = 'users';
  static const String groups = 'groups';
  static const String myGroups = 'myGroups'; // my groups
  static const String locations = 'locations';
  static const String locationsCheckIn = 'locationsCheckIns';
}

class CollectionStore {
  CollectionStore._();

  static CollectionReference<Map<String, dynamic>> users =
      FirebaseFirestore.instance.collection(CollectionStoreConstant.users);

  static CollectionReference<Map<String, dynamic>> groups =
      FirebaseFirestore.instance.collection(CollectionStoreConstant.groups);

  static CollectionReference<Map<String, dynamic>> myGroups =
      FirebaseFirestore.instance.collection(CollectionStoreConstant.myGroups);

  static CollectionReference<Map<String, dynamic>> locations =
      FirebaseFirestore.instance.collection(CollectionStoreConstant.locations);

  static CollectionReference<Map<String, dynamic>> locationCheckIns =
      FirebaseFirestore.instance
          .collection(CollectionStoreConstant.locationsCheckIn);
}
