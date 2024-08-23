/// Abstract class extended by  [TvShow] and [Movie]

abstract class Watchable {
  final String name;
  final String url;
  final int id;
  final String slug;

  const Watchable(
      {required this.name,
      required this.url,
      required this.id,
      required this.slug});
}
