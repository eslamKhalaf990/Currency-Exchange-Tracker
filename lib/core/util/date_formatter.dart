import 'package:intl/intl.dart';

class DateFormatter {
  static String formatString(String dateStr) {
    try {
      final DateTime dateTime = DateTime.parse(dateStr);
      return DateFormat('EEEE, dd MMM yy').format(dateTime);
    } catch (_) {
      return dateStr;
    }
  }
}
