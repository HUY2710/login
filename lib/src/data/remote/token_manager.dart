import '../../global/global.dart';
import '../local/shared_preferences_manager.dart';
import 'collection_store.dart';
import 'group_manager.dart';

class TokenManager {
  TokenManager._();

  static Future<void> updateMyFCMToken() async {
    final token = await SharedPreferencesManager.getFCMToken();
    final groupIds = await GroupsManager.getIdMyListGroup() ?? [];
    if (groupIds.isEmpty) {
      return;
    }

    final code = Global.instance.userCode;

    if (code.isEmpty) {
      return;
    }

    for (final element in groupIds) {
      CollectionStore.tokens
          .doc(element)
          .collection(CollectionStoreConstant.users)
          .doc(code)
          .set({'token': token});
    }
  }

  static Future<List<String>> getGroupTokens() async {
    final groupId = Global.instance.group?.idGroup;
    if (groupId == null) {
      return [];
    }

    final snapShots = await CollectionStore.tokens
        .doc(groupId)
        .collection(CollectionStoreConstant.users)
        .get();
    if (snapShots.docs.isEmpty) {
      return [];
    }

    final tokens = snapShots.docs
        .where((element) => element.id != Global.instance.userCode)
        .toList()
        .map((e) => e.data()['token'] as String)
        .toList()
        .where((element) => element.isNotEmpty)
        .toList();
    return tokens;
  }

  static Future<List<String>> getAllGroupTokens() async {
    //lấy ra toàn bộ id group mình join
    final List<String> tokens = [];
    final List<String>? myGroupsId = await GroupsManager.getIdMyListGroup();
    if (myGroupsId == null || myGroupsId.isEmpty) {
      return [];
    }

    for (final idGroup in myGroupsId) {
      final snapShots = await CollectionStore.tokens
          .doc(idGroup)
          .collection(CollectionStoreConstant.users)
          .get();
      if (snapShots.docs.isEmpty) {
        return [];
      }
      final token = snapShots.docs
          .where((element) => element.id != Global.instance.userCode)
          .toList()
          .map((e) => e.data()['token'] as String)
          .toList()
          .where((element) => element.isNotEmpty)
          .toList();

      tokens.addAll(token);
    }

    return tokens;
  }

  static Future<void> updateGroupNotification(bool mute, String groupId) async {
    String token = '';
    if (!mute) {
      token = await SharedPreferencesManager.getFCMToken();
    }

    final code = Global.instance.userCode;

    if (code.isEmpty) {
      return;
    }

    return CollectionStore.tokens
        .doc(groupId)
        .collection(CollectionStoreConstant.users)
        .doc(code)
        .set({'token': token});
  }
}
