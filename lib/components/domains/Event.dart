import 'package:my_video_log/components/domains/log_record.dart';

class Event {
  final String title;
  final LogRecord logRecord;

  const Event(this.title, this.logRecord);

  @override
  String toString() => title;
}