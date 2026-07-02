import 'package:intl/intl.dart';

/// 금액/날짜 포매팅 유틸.
class Formatters {
  Formatters._();

  static final NumberFormat _won = NumberFormat('#,###', 'ko_KR');

  static String won(int amount) => '${_won.format(amount)}원';

  static String date(DateTime d) =>
      DateFormat('yyyy.MM.dd (E)', 'ko_KR').format(d);

  static String dateTime(DateTime d) =>
      DateFormat('yyyy.MM.dd (E) a h:mm', 'ko_KR').format(d);

  static String time(DateTime d) => DateFormat('a h:mm', 'ko_KR').format(d);

  static String duration(int minutes) => '$minutes분';
}
