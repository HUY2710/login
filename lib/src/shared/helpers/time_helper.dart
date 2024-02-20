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

  static bool checkTimeDifferenceCurrent(DateTime time) {
    final DateTime currentTime = DateTime.now();
    final Duration difference = currentTime.difference(time);

    final bool isDifferenceGreaterThan15Minutes = difference.inMinutes > 15;
    if (isDifferenceGreaterThan15Minutes) {
      return true;
    } else {
      return false;
    }
  }
}
