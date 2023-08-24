import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreConstant {
  static const String users = 'users';
}

class FirestoreClient {
  FirestoreClient._privateConstructor();

  static final FirestoreClient instance = FirestoreClient._privateConstructor();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
}
