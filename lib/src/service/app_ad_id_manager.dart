import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:injectable/injectable.dart';

import '../data/model/ad_unit_id/ad_unit_id_model.dart';
import '../shared/helpers/env_params.dart';

@singleton
class AppAdIdManager extends IAdIdManager {
  @override
  AppAdIds? get admobAdIds => AppAdIds(
        appId: EnvParams.appId,
      );

  late AdUnitIdModel adUnitId;

  final String largeNativeFactory = 'LargeNative';
  final String smallNativeFactory = 'SmallNative';
  final String nonMediaBottomNativeFactory = 'NonMediaBottomNative';
  final String nonMediaTopNativeFactory = 'NonMediaTopNative';
}
