import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeDayUtil {

  static TimeOfDay converterTimeOfDay(String timeString) {
    List<String> parts = timeString.split(':');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }

  static String converterTimeOfDayToString(TimeOfDay timeOfDay) {
    final formattedTime = DateFormat('HH:mm').format(DateTime(2022, 1, 1, timeOfDay.hour, timeOfDay.minute));
    return formattedTime;
  }

}
