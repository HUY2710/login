import 'package:firebase_remote_config/firebase_remote_config.dart';

enum AdKey { banner, inter, open_app }

extension AdKeyExt on AdKey {
  String get value {
    return toString().split('.').last;
  }

  static AdKey fromString(String string) {
    return AdKey.values
        .firstWhere((AdKey e) => e.toString() == 'AdKey.$string');
  }
}

class ConfigItem {
  ConfigItem(this.value, this.key);

  final bool value;
  final AdKey key;
}

class RemoteConfigManager {
  RemoteConfigManager._privateConstructor();

  static final RemoteConfigManager instance =
      RemoteConfigManager._privateConstructor();

  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  List<ConfigItem> _items = [];

  Future<void> initConfig() async {
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(
          seconds: 1), // a fetch will wait up to 10 seconds before timing out
      minimumFetchInterval: const Duration(
          seconds:
              10), // fetch parameters will be cached for a maximum of 1 hour
    ));

    await _fetchConfig();
  }

  bool isShowAd(AdKey key) {
    return _items.firstWhere((ConfigItem element) => element.key == key).value;
  }

  void _getConfigValue() {
    _items.clear();
    for (final AdKey key in AdKey.values) {
      final bool value = _remoteConfig.getBool(key.value);
      _items.add(ConfigItem(value, key));
    }
  }

  Future<void> _fetchConfig() async {
    await _remoteConfig.fetchAndActivate();
    _getConfigValue();
  }
}
