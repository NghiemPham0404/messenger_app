import 'package:intl/intl.dart';

///
/// covert iso string to readable text
///
/// @params:
/// - isoDate : String (like : 2025-06-13T16:35:55.609090)
///
/// @return example:
/// - less than a minute : "just now"
/// - less than a hours : 56 minutes ago, 32 minutes ago,...
/// - less than a day : 8 hours ago, 9 hours ago,..
/// - less than a week : Monday, Tuesday,...
/// - less than a year : 23/4, 30/5,....
/// - other : 21/2/2023, 12/8/2024,...
///
String formatReadableDate(String isoDate) {
  final date = DateTime.parse(isoDate).toLocal();
  final now = DateTime.now();

  final diff = now.difference(date);

  if (diff.inSeconds < 60) {
    return "just now";
  } else if (diff.inMinutes < 60) {
    return "${diff.inMinutes} minute${diff.inMinutes > 1 ? 's' : ''} ago";
  } else if (diff.inHours < 24) {
    return "${diff.inHours} hour${diff.inHours > 1 ? 's' : ''} ago";
  } else if (diff.inDays == 1) {
    return "yesterday";
  } else if (diff.inDays < 7) {
    return DateFormat('EEEE').format(date); // e.g. "Tuesday"
  } else if (now.year == date.year) {
    return DateFormat('d/M').format(date); // e.g. "25/5"
  } else {
    return DateFormat('d/M/yyyy').format(date); // e.g. "21/2/2024"
  }
}

String formatReadableDateChat(String isoDate) {
  final date = DateTime.parse(isoDate).toLocal();
  final now = DateTime.now();

  final diff = now.difference(date);

  if (diff.inSeconds < 60) {
    return "just now";
  } else if (diff.inDays < 1) {
    return DateFormat('HH:mm').format(date);
  } else if (diff.inDays == 1) {
    return DateFormat('yesterday HH:mm').format(date);
  } else if (diff.inDays < 7) {
    return DateFormat('EEEE  HH:mm').format(date); // e.g. "Tuesday"
  } else if (now.year == date.year) {
    return DateFormat('d/M  HH:mm').format(date); // e.g. "25/5"
  } else {
    return DateFormat('d/M/yyyy  HH:mm').format(date); // e.g. "21/2/2024"
  }
}

///
/// covert datetime to iso string with local offset
///
/// @params:
/// - dateTime : Datetime
///
/// @return :
/// - IsoStringWithLocal : String . example : 2025-06-13T16:35:55.609090+07:00
String toIsoStringWithLocal(DateTime dateTime) {
  final duration = dateTime.timeZoneOffset;
  final hours = duration.inHours.abs().toString().padLeft(2, '0');
  final minutes = (duration.inMinutes.abs() % 60).toString().padLeft(2, '0');
  final sign = duration.isNegative ? '-' : '+';
  final offset = '$sign$hours:$minutes';

  return dateTime.toIso8601String() + offset;
}

void main() {
  print(toIsoStringWithLocal(DateTime.now()));
}
