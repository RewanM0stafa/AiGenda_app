/*import 'package:intl/intl.dart';


class DateUtils {
  static final DateTime minDate = DateTime(1940, 1, 1);

  static DateTime safeParse(String? date) {
    if (date == null || date.isEmpty) {
      return DateTime(2000, 1, 1);
    }

    final parsed = DateTime.tryParse(date);

    if (parsed == null || parsed.isBefore(minDate)) {
      return DateTime(2000, 1, 1);
    }

    return parsed;
  }

  static bool isValidDate(String? date) {
    if (date == null || date.isEmpty) return false;

    final parsed = DateTime.tryParse(date);
    if (parsed == null) return false;

    return !parsed.isBefore(minDate);
  }


  static String format(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }
}

 */


import 'package:intl/intl.dart';

class AppDateUtils {
  static final DateTime _minDate = DateTime(1940, 1, 1);
  static final DateTime _fallback = DateTime(2000, 6, 15);

  /// Parse string → DateTime, fallback لو مش صح
  static DateTime safeParse(String? raw) {
    if (raw == null || raw.trim().isEmpty) return _fallback;
    final parsed = DateTime.tryParse(raw.trim());
    if (parsed == null || parsed.isBefore(_minDate)) return _fallback;
    return parsed;
  }

  /// هل التاريخ صح ومنطقي؟
  static bool isValid(String? raw) {
    if (raw == null || raw.trim().isEmpty) return false;
    final parsed = DateTime.tryParse(raw.trim());
    return parsed != null && !parsed.isBefore(_minDate);
  }

  /// DateTime → "yyyy-MM-dd"  (للـ API)
  static String toApiFormat(DateTime date) =>
      DateFormat('yyyy-MM-dd').format(date);

  /// DateTime → "dd/MM/yyyy"  (للـ UI)
  static String toDisplayFormat(DateTime date) =>
      DateFormat('dd/MM/yyyy').format(date);

  /// String (yyyy-MM-dd) → "dd/MM/yyyy" للعرض
  static String formatForDisplay(String? raw) {
    final date = safeParse(raw);
    return toDisplayFormat(date);
  }
}