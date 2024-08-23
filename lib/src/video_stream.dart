import 'media_stream.dart';

/// A class that represents a single video stream with its resolution and codecs
class VideoStream extends MediaStream {
  final String resolution;
  final List<String> codecs;

  const VideoStream(
      {required super.url, required this.resolution, required this.codecs});

  @override
  String toString() {
    return "${url.toString()} $codecs $resolution";
  }
}
