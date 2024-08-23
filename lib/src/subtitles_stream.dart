import 'media_stream.dart';

class SubtitlesStream extends MediaStream {
  final String language;

  SubtitlesStream({required super.url, required this.language});
}
