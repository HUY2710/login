import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:injectable/injectable.dart';

import '../../src/shared/helpers/env_params.dart';
import 'model/ad_unit_id/ad_unit_id_model.dart';

@singleton
class AppAdIdManager extends IAdIdManager {
  @override
  AppAdIds? get admobAdIds => AppAdIds(
        appId: EnvParams.appId,
      );

  late AdUnitIdModel adUnitId;

  final String topLargeNativeFactory = 'TopLargeNative';
  final String bottomLargeNativeFactory = 'BottomLargeNative';
  final String topSmallNativeFactory = 'TopSmallNative';
  final String bottomSmallNativeFactory = 'BottomSmallNative';
}
