import 'package:intl/intl.dart';

String getFormattedDate(DateTime date) {
  return DateFormat.yMMMd().format(date);
}

DateTime parseFormattedDate(String dateStr) {
return DateFormat.yMMMd().parse(dateStr);
}