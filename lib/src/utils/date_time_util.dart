import 'package:intl/intl.dart';

class DateTimeUtil {
  static String weekDayName(date) => DateFormat('EEEE').format(date);

  static DateTime findFirstDateOfTheWeek(DateTime dateTime) {
    return dateTime.subtract(Duration(days: dateTime.weekday - 1));
  }

  static DateTime findLastDateOfTheWeek(DateTime dateTime) {
    return dateTime
        .add(Duration(days: DateTime.daysPerWeek - dateTime.weekday));
  }
}
