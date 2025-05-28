import 'package:intl/intl.dart';

String? formatArabicNumber(int? number) {
  try {
    return number == null ? null : NumberFormat('#.##', 'ar_EG').format(number);
  } on Exception catch (_) {
    return null;
  }
}
