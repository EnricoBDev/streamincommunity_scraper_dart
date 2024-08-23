import 'media_stream.dart';

class AudioStream extends MediaStream {
  final String language;

  AudioStream({required super.url, required this.language});
}
