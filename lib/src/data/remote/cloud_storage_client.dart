import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';

const String folderName = 'chats';

class FirebaseStorageClient {
  FirebaseStorageClient._privateConstructor();
  static final FirebaseStorageClient instance =
      FirebaseStorageClient._privateConstructor();

  final _firebaseStorage = FirebaseStorage.instance.ref().child(folderName);

  Future<String> uploadImage(
      {required String idGroup, required File imageFile}) async {
    String imageUrl = '';
    try {
      final result = await _firebaseStorage
          .child('$idGroup/${DateTime.now().millisecondsSinceEpoch}')
          .putFile(
              imageFile,
              SettableMetadata(
                contentType: 'image/jpeg',
              ));
      final urlTemp = await result.ref.getDownloadURL();
      imageUrl = urlTemp;
    } catch (e) {
      debugPrint('Upload image fail: $e');
    }

    return imageUrl;
  }
}
