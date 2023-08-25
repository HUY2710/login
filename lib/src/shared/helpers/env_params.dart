import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvParams {
  EnvParams._();

  static String get _suffix => Platform.isAndroid ? 'ANDROID' : 'IOS';

  static String get appId => dotenv.get('APP_ID_$_suffix');
}
