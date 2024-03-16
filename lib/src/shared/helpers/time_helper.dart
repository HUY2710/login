import 'package:intl/intl.dart';

class TimerHelper {
  TimerHelper._();

  static String? formatTimeHHMM(DateTime? time) {
    // Định dạng thời gian thành "hh:mm"
    if (time != null) {
      final String formattedTime = DateFormat('HH:mm').format(time);
      return formattedTime;
    }
    return null;
  }

  static bool checkTimeDifferenceCurrent(DateTime time, {int? argMinute}) {
    final DateTime currentTime = DateTime.now();
    final Duration difference = currentTime.difference(time);

    final bool isDifference = difference.inMinutes > (argMinute ?? 15);
    if (isDifference) {
      return true;
    } else {
      return false;
    }
  }

  static bool checkHourTime(DateTime time, int hour) {
    final DateTime currentTime = DateTime.now();
    final Duration difference = currentTime.difference(time);

    final bool isDifference = difference.inHours > hour;
    if (isDifference) {
      return true;
    } else {
      return false;
    }
  }
}
