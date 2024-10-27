import 'package:intl/intl.dart';

String getFormattedDate(DateTime date) {
  return DateFormat.yMMMd().format(date);
}
