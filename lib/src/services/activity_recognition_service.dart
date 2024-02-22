import 'package:flutter/material.dart';
import 'package:flutter_activity_recognition/flutter_activity_recognition.dart';

import '../data/remote/firestore_client.dart';
import '../global/global.dart';

class ActivityRecognitionService {
  ActivityRecognitionService._privateConstructor();

  static final ActivityRecognitionService instance =
      ActivityRecognitionService._privateConstructor();
  final FirestoreClient _firestoreClient = FirestoreClient.instance;
  String? oldActivity = Global.instance.user?.activityType;
  final activityRecognition = FlutterActivityRecognition.instance;
  Future<bool> isPermissionGrants() async {
    // Check if the user has granted permission. If not, request permission.
    PermissionRequestResult reqResult;
    reqResult = await activityRecognition.checkPermission();
    if (reqResult == PermissionRequestResult.PERMANENTLY_DENIED) {
      debugPrint('Permission is permanently denied.');
      return false;
    } else if (reqResult == PermissionRequestResult.DENIED) {
      reqResult = await activityRecognition.requestPermission();
      if (reqResult != PermissionRequestResult.GRANTED) {
        debugPrint('Permission is denied.');
        return false;
      }
    }
    return true;
  }

  Future<void> initStreamActivityRecognition() async {
    final status = await isPermissionGrants();
    if (status) {
      activityRecognition.activityStream.handleError((error) {}).listen(
        (Activity activity) {
          debugPrint('activity:${activity.confidence.name}');
          debugPrint('activity:$activity');
          if (oldActivity != activity.type.name) {
            //hoat động đã thay đổi => cập nhật lên server
            oldActivity = activity.type.name;
            // cật nhật user local
            Global.instance.user = Global.instance.user
                ?.copyWith(activityType: oldActivity ?? 'STILL');
            _firestoreClient.updateUser({'activityType': oldActivity});
          }
        },
      );
    }
  }
}
