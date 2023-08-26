import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';

import '../../../flavors.dart';
import '../../config/di/di.dart';
import '../../data/model/ad_unit_id_model.dart';
import '../../service/app_ad_id_manager.dart';

mixin LoadData {
  Future<void> loadAdUnitId() async {
    final String environment = F.appFlavor == Flavor.dev ? 'dev' : 'prod';
    final String platform = Platform.isAndroid ? 'android' : 'ios';
    final String filePath =
        'assets/ad_unit_id/$environment/ad_id_$platform.json';
    final String text = await rootBundle.loadString(filePath);
    final Map<String, dynamic> json = jsonDecode(text) as Map<String, dynamic>;

    getIt<AppAdIdManager>().adUnitId = AdUnitIdModel.fromJson(json);
  }
}
