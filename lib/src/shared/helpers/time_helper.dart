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
}
