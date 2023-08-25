import '../utils/log_utils.dart';
import '../utils/logger_utils.dart';

mixin LogMixin on Object {
  void logD(String message, {DateTime? time}) {
    Log.d(message, name: runtimeType.toString(), time: time);
  }

  void logE(
    Object? errorMessage, {
    Object? clazz,
    Object? errorObject,
    StackTrace? stackTrace,
    DateTime? time,
  }) {
    Log.e(
      errorMessage,
      name: runtimeType.toString(),
      errorObject: errorObject,
      stackTrace: stackTrace,
      time: time,
    );
  }

  void logDebug(String message) {
    LoggerUtil.logDebug(message);
  }

  void logInfo(String message) {
    LoggerUtil.logInfo(message);
  }

  void logWarning(String message) {
    LoggerUtil.logWarning(message);
  }

  void logError(String message) {
    LoggerUtil.logError(message);
  }

  void logVerbose(String message) {
    LoggerUtil.logVerbose(message);
  }
}
