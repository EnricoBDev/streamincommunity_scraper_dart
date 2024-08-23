abstract class MediaStream {
  final Uri url;

  const MediaStream({required this.url});

  @override
  String toString() {
    return url.toString();
  }
}
