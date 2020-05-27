import 'package:intl/intl.dart';

String composeAgoTime(DateTime date) {
  final difference = DateTime.now().difference(date);

  if (difference.inSeconds < 60) return "сейчас";

  if (difference.inMinutes < 60)
    return difference.inMinutes.toString() +
        (difference.inMinutes > 1 ? " мин" : " мин");

  if (difference.inHours < 24)
    return difference.inHours.toString() +
        (difference.inHours > 1 ? " ч." : " ч.");

  if (difference.inDays < 7)
    return difference.inDays.toString() +
        (difference.inDays > 1 ? " дн." : " дн.");

  if (difference.inDays < 7 * 4) {
    final weeks = difference.inDays.toDouble() ~/ 7.0;
    return weeks.toString() + (weeks > 1 ? " нед." : " нед.");
  }

  return DateFormat.MMMd('ru').format(date);
}

String leftTime(DateTime date) {
  final difference = date.difference(DateTime.now());

  if (difference.inSeconds < 60) return "${difference.inSeconds} сек";

  if (difference.inMinutes < 60)
    return difference.inMinutes.toString() +
        (difference.inMinutes > 1 ? " мин" : " мин");

  if (difference.inHours < 24)
    return difference.inHours.toString() +
        (difference.inHours > 1 ? " ч." : " ч.");

  if (difference.inDays < 7)
    return difference.inDays.toString() +
        (difference.inDays > 1 ? " дн." : " дн.");

  if (difference.inDays < 7 * 4) {
    final weeks = difference.inDays.toDouble() ~/ 7.0;
    return weeks.toString() + (weeks > 1 ? " нед." : " нед.");
  }

  return DateFormat.MMMd().format(date);
}
