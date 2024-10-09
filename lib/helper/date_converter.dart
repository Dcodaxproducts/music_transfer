import 'package:intl/intl.dart';

class DateConverter {
  static convertDate(DateTime date) {
    return DateFormat('dd MMM, yyyy - hh:mm a').format(date);
  }
}
