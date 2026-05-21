import 'package:intl/intl.dart';

abstract final class AppDateTimeFormatter {
  static const Duration _utcPlus7Offset = Duration(hours: 7);

  static DateTime toUtcPlus7(DateTime value) {
    return value.toUtc().add(_utcPlus7Offset);
  }

  static String formatDateTimeUtcPlus7(DateTime value) {
    return DateFormat('dd/MM/yyyy HH:mm').format(toUtcPlus7(value));
  }
}
