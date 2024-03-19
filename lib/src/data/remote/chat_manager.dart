import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'collection_store.dart';

class ChatManager {
  const ChatManager._();

  static Future<void> removeGroupChat(String idGroup) async {
    try {
      final col = CollectionStore.chat
          .doc(idGroup)
          .collection(CollectionStoreConstant.messages);
      final WriteBatch batch = FirebaseFirestore.instance.batch();
      final snapShot = await col.get();
      for (final snap in snapShot.docs) {
        batch.delete(snap.reference);
      }
      await batch.commit();
      await CollectionStore.chat.doc(idGroup).delete();
    } catch (e) {
      debugPrint('Error Remove group chat: $e');
    }
  }
}
