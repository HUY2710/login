import 'dart:io';

import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../global/global.dart';

mixin PermissionMixin {
  // TODO(son): Xóa nếu không cần thiết
  //Ví dụ về yêu cầu quyền truy cập và lưu trữ ảnh
  Future<PermissionStatus> checkStoragePermission() async {
    PermissionStatus status;
    if (Platform.isAndroid) {
      status = await _checkStoragePermissionOnAndroid();
    } else {
      status = await _checkStoragePermissionOnIOS();
    }
    return status;
  }

  Future<PermissionStatus> requestStoragePermission() async {
    PermissionStatus status = PermissionStatus.denied;
    bool isPermanentlyDenied = false;
    if (Platform.isAndroid) {
      if (Global.instance.androidSdkVersion <= 31) {
        isPermanentlyDenied = await Permission.storage.isPermanentlyDenied;
      } else {
        isPermanentlyDenied = await Permission.photos.isPermanentlyDenied;
      }
    } else {
      isPermanentlyDenied = await Permission.photos.isPermanentlyDenied;
    }
    if (isPermanentlyDenied) {
      EasyAds.instance.appLifecycleReactor?.setIsExcludeScreen(true);
      await openAppSettings();
    } else {
      status = await _requestPermission();
    }
    return status;
  }

  Future<PermissionStatus> _requestPermission() async {
    PermissionStatus status;
    if (Platform.isAndroid) {
      if (Global.instance.androidSdkVersion <= 31) {
        status = await Permission.storage.request();
      } else {
        status = await Permission.photos.request();
      }
    } else {
      status = await Permission.photos.request();
    }
    return status;
  }

  Future<PermissionStatus> _checkStoragePermissionOnIOS() async {
    final PermissionStatus status = await Permission.photos.status;
    return status;
  }

  Future<PermissionStatus> _checkStoragePermissionOnAndroid() async {
    PermissionStatus status;
    if (Global.instance.androidSdkVersion <= 31) {
      status = await Permission.storage.status;
    } else {
      status = await Permission.photos.status;
    }
    return status;
  }
}
