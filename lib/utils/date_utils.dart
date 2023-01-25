import 'package:intl/intl.dart';
class MyDateUtils {
  static String dateFormat(DateTime date){
    DateFormat formatter = DateFormat('dd-MM-yyyy');
    return formatter.format(date);
  }
  static DateTime extractDate(DateTime datetime){
    return DateTime(datetime.year,datetime.month,datetime.day);
  }
}

