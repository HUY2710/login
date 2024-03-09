import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../module/admob/enum/ad_remote_key.dart';
import '../../module/admob/enum/remote_key.dart';
import '../../module/iap/my_purchase_manager.dart';
import 'di/di.dart';

class ConfigItem {
  ConfigItem(this.value, this.key);

  final bool value;
  final AdRemoteKeys key;
}

class RemoteConfigManager {
  RemoteConfigManager._privateConstructor();

  static final RemoteConfigManager instance =
      RemoteConfigManager._privateConstructor();
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;
  final List<ConfigItem> _items = [];
  bool willShowAd = true;

  Future<void> initConfig() async {
    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(
          seconds: 1,
        ), // a fetch will wait up to 10 seconds before timing out
        minimumFetchInterval: const Duration(
          seconds: 10,
        ), // fetch parameters will be cached for a maximum of 1 hour
      ),
    );

    await _remoteConfig.activate();
    await Future.delayed(const Duration(seconds: 1));
    await _fetchConfig();

    await checkRemoteWillShowAd();
  }

  Future<void> checkRemoteWillShowAd() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final version = packageInfo.version;
    final offVersion = _remoteConfig.getString(RemoteKeys.adOffVersion.name);

    willShowAd = offVersion != version;
  }

  Future<void> _fetchConfig([bool refresh = false]) async {
    try {
      await _remoteConfig.fetchAndActivate();
      _getConfigValue();
    } catch (_) {
      if (!refresh) {
        _fetchConfig(true);
      }
    }
  }

  bool globalShowAd() {
    if (getIt<MyPurchaseManager>().state.isPremium()) {
      return false;
    }
    return willShowAd && _remoteConfig.getBool(AdRemoteKeys.show.platformKey);
  }

  bool isShowAd(AdRemoteKeys key) {
    return globalShowAd() &&
        _items
            .firstWhere(
              (ConfigItem element) => element.key == key,
              orElse: () => ConfigItem(false, key),
            )
            .value;
  }

  void _getConfigValue() {
    _items.clear();
    for (final AdRemoteKeys key in AdRemoteKeys.values) {
      final bool value = _remoteConfig.getBool(key.platformKey);
      _items.add(ConfigItem(value, key));
    }
  }

  bool isForceUpdate() {
    return _remoteConfig.getBool(RemoteKeys.forceUpdate.platformKey);
  }

  bool isShowSkipIntroButton() =>
      _remoteConfig.getBool(RemoteKeys.showSkipIntroButton.platformKey);

  bool isShowRate() {
    return _remoteConfig.getBool(AdRemoteKeys.show_rate.platformKey);
  }
}
