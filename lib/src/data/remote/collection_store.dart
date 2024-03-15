import 'package:cloud_firestore/cloud_firestore.dart';

class CollectionStoreConstant {
  CollectionStoreConstant._();
  static const String users = 'users';
  static const String groups = 'groups';
  static const String members = 'members';
  static const String places = 'places';
  static const String historyPlacesOfUser =
      'historyPlacesOfUser'; //mỗi group, mỗi user sẽ có history places khác nhau
  static const String historyPlaces = 'historyPlaces';
  static const String myGroups = 'myGroups'; // my groups
  static const String locations = 'locations';
  static const String locationsCheckIn = 'locationsCheckIns';

  static const String chat = 'chat';
  static const String messages = 'messages';
  static const String tokens = 'tokens';
  static const String notificationPlace =
      'notificationPlaces'; //mỗi place thì mỗi user cần có thông tin leave && arrived// update lại

  static const String sos = 'sos';
}

class CollectionStore {
  CollectionStore._();

  static CollectionReference<Map<String, dynamic>> users =
      FirebaseFirestore.instance.collection(CollectionStoreConstant.users);

  static CollectionReference<Map<String, dynamic>> groups =
      FirebaseFirestore.instance.collection(CollectionStoreConstant.groups);

  //collection to listen realtime user join/out group
  static CollectionReference<Map<String, dynamic>> members =
      FirebaseFirestore.instance.collection(CollectionStoreConstant.members);
  static CollectionReference<Map<String, dynamic>> places =
      FirebaseFirestore.instance.collection(CollectionStoreConstant.places);

  static CollectionReference<Map<String, dynamic>> myGroups =
      FirebaseFirestore.instance.collection(CollectionStoreConstant.myGroups);

  static CollectionReference<Map<String, dynamic>> locations =
      FirebaseFirestore.instance.collection(CollectionStoreConstant.locations);

  static CollectionReference<Map<String, dynamic>> locationCheckIns =
      FirebaseFirestore.instance
          .collection(CollectionStoreConstant.locationsCheckIn);
  static CollectionReference<Map<String, dynamic>> chat =
      FirebaseFirestore.instance.collection(CollectionStoreConstant.chat);

  static CollectionReference<Map<String, dynamic>> tokens =
      FirebaseFirestore.instance.collection(CollectionStoreConstant.tokens);

  static CollectionReference<Map<String, dynamic>> notificationPlaces =
      FirebaseFirestore.instance
          .collection(CollectionStoreConstant.notificationPlace);

  static CollectionReference<Map<String, dynamic>> sos =
      FirebaseFirestore.instance.collection(CollectionStoreConstant.sos);
}
