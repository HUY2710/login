import 'package:firebase_remote_config/firebase_remote_config.dart';

import '../shared/enum/ads/ad_remote_key.dart';

class ConfigItem {
  ConfigItem(this.value, this.key);

  final bool value;
  final AdRemoteKeys key;
}

class RemoteConfigManager {
  RemoteConfigManager._privateConstructor();
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;
  final List<ConfigItem> _items = [];
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

    await _fetchConfig();
  }

  Future<void> _fetchConfig() async {
    await _remoteConfig.fetchAndActivate();
    // _getConfigValue();
  }

  bool globalShowAd() {
    return _items
        .firstWhere((ConfigItem e) => e.key == AdRemoteKeys.show)
        .value;
  }

  bool isShowAd(AdRemoteKeys key) {
    return globalShowAd() &&
        _items.firstWhere((ConfigItem element) => element.key == key).value;
  }

  void _getConfigValue() {
    _items.clear();
    for (final AdRemoteKeys key in AdRemoteKeys.values) {
      final bool value = _remoteConfig.getBool(key.keyName);
      _items.add(ConfigItem(value, key));
    }
  }
}
