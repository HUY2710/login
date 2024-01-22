import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class LoggerUtils {
  LoggerUtils._();
  static final _logger = Logger();
  static void logInfo(String message) {
    if (!kDebugMode) {
      return;
    }
    _logger.i(message);
  }

  static void logError(String message) {
    if (!kDebugMode) {
      return;
    }
    _logger.e(message);
  }
}
