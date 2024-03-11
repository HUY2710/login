import 'dart:math';

import 'package:flutter/services.dart';
import 'package:uni_links/uni_links.dart';

class UniServices {
  static String _code = '';
  static String get code => _code;
  static bool get hasCode => _code.isNotEmpty;

  static void reset() => _code = '';

  static init() async {
    try {
      final uri = await getInitialLink();
      uniHandler(uri as Uri?);
    } on PlatformException {
      print('Failed to receive the code');
    } on FormatException {
      log('wrong foramt code received' as num);
    }
    uriLinkStream.listen((Uri? uri) {
      uniHandler(uri);
    }, onError: (e) {
      log(e);
    });
  }

  static void uniHandler(Uri? uri) {
    if (uri == null || uri.queryParameters.isEmpty) return;
    final Map<String, String> param = uri.queryParameters;

    final String receivedCode = param['code'] ?? '';
    
  }
}
