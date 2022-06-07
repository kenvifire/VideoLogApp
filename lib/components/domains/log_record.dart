class LogRecord {
  final String id;
  final DateTime date;
  final String? videoPath;
  final String thumbnailUrl;
  final String? videoUrl;

  LogRecord({required this.id, required this.date, this.videoPath, required this.thumbnailUrl, this.videoUrl});
}