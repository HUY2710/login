import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvParams {
  EnvParams._();

  static String get _platform => Platform.isAndroid ? 'ANDROID' : 'IOS';

  static String get appId => dotenv.get('APP_ID_$_platform');

  static String get appsflyerKey => dotenv.get('APPSFLYER_KEY');

  static String get appLovinKey => dotenv.get('APPLOVIN_KEY');

  static String get apiKey => dotenv.get('API_KEY');

  static String get apiKeyIOS => dotenv.get('API_KEY_IOS');

  static String get apiUrlNotification => dotenv.get('API_URL_NOTIFICATION');
}
