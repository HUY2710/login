import 'dart:io';

import 'package:app_settings/app_settings.dart';
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

  Future<PermissionStatus> checkPermissionLocation() async {
    final PermissionStatus locationStatus =
        await Permission.locationWhenInUse.status;
    return locationStatus;
  }

  Future<bool> requestPermissionLocation() async {
    final reject = await Permission.locationWhenInUse.isPermanentlyDenied;
    if (reject) {
      await openAppSettings();
    }
    final status = await Permission.locationWhenInUse.request();
    return status.isGranted;
  }

  Future<bool> checkPermissionCamera() async {
    final PermissionStatus cameraStatus = await Permission.camera.status;
    return cameraStatus.isGranted;
  }

  Future<bool> requestPermissionCamera() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  Future<bool> checkPermissionGallery() async {
    final PermissionStatus galleryStatus = await Permission.photos.status;
    bool requestSuccess = galleryStatus.isGranted;
    if (!requestSuccess) {
      requestSuccess = await requestPermissionGallery();
    }
    return requestSuccess;
  }

  Future<bool> requestPermissionGallery() async {
    final status = await Permission.photos.request();
    return status.isGranted;
  }

  //check location alway permission
  Future<bool> statusLocationAlways() async {
    final PermissionStatus locationAlwaysStatus =
        await Permission.locationAlways.status;
    return locationAlwaysStatus.isGranted;
  }

  //notification
  Future<bool> requestNotification() async {
    final PermissionStatus notificationStatus =
        await Permission.notification.request();
    if (notificationStatus.isPermanentlyDenied || notificationStatus.isDenied) {
      await AppSettings.openAppSettings(type: AppSettingsType.notification);
      return notificationStatus.isGranted;
    }
    return notificationStatus.isGranted;
  }

  Future<bool> requestActivityRecognition() async {
    PermissionStatus activityRecognition;
    if (Platform.isIOS) {
      activityRecognition = await Permission.sensors.request();
    } else {
      activityRecognition = await Permission.activityRecognition.request();
    }
    return activityRecognition.isGranted;
  }
}
