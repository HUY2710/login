import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:injectable/injectable.dart';

import '../../src/shared/helpers/logger_utils.dart';

enum FirebaseEvent {
  user_payment,
}

@singleton
class FirebaseEventService {
  FirebaseEventService() {
    _init();
  }

  late final String? uuid;

  Future<void> _init() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      final iosDeviceInfo = await deviceInfo.iosInfo;
      uuid = iosDeviceInfo.identifierForVendor;
    } else if (Platform.isAndroid) {
      final androidDeviceInfo = await deviceInfo.androidInfo;
      uuid = androidDeviceInfo.id;
    }
  }

  Future<void> logEvent({
    required String name,
    required Map<String, dynamic> param,
  }) async {
    try {
      await FirebaseAnalytics.instance.logEvent(
        name: name,
        parameters: param,
      );
      logger.i('firebase event: $name');
    } catch (e) {
      logger.e(e);
    }
  }

  void logUserPayment(String productId) {
    logEvent(
      name: FirebaseEvent.user_payment.name,
      param: {
        'productId': productId,
      },
    );
  }
}
