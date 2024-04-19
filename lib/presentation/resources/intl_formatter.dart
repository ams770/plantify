

import 'package:easy_localization/easy_localization.dart';

import 'constants_manager.dart';
import 'language_manager.dart';

class IntlFormatter {
  static String timeFormat(DateTime date) {
    return DateFormat("h:mm a", localName).format(date);
  }
  //localName

  static String dateFormat(DateTime date) {
    return DateFormat(DateFormat.YEAR_MONTH_DAY, localName).format(date);
  }
  //localName

  static String dateWeekDayFormat(DateTime date) {
    return DateFormat(DateFormat.YEAR_ABBR_MONTH_WEEKDAY_DAY, localName).format(date);
  }
  //localName


  static String periodFormat(DateTime date) {
    return DateFormat(DateFormat.ABBR_STANDALONE_MONTH, localName).format(date);
  }
  //localName

  static String get localName => LanguageType.ENGLISH.getValue();

}