import 'package:puppeteer/puppeteer.dart';

import 'browser_connection.dart';
import 'source.dart';
import 'watchable.dart';
import 'constants.dart';

/// A class that represents a movie and its details
class Movie extends Watchable {
  const Movie(
      {required super.url,
      required super.name,
      required super.id,
      required super.slug});

  String get _iframeUrl => "$BASE_URL/iframe/$id";

  /// Gets the sources that serve this movie
  /// example:
  /// ```dart
  /// Movie movie = Movie(
  ///        url: "$BASE_URL/26-hunger-games",
  ///        name: "Hunger Games",
  ///        id: 26,
  ///        slug: "hunger-games");
  ///
  ///List<Source> sources = await movie.getSources();
  /// ```
  Future<List<Source>> getSources() async {
    Browser? browser = await BrowserConnection.getBrowser(SERVER_URL);
    Page page = await browser!.newPage();

    await page.goto(_iframeUrl,
        wait: Until.networkIdle, timeout: Duration.zero);

    ElementHandle iframe =
        await page.$("html"); // takes the whole html page of the /iframe url
    Frame? contentFrame = await iframe.contentFrame;
    Frame childFrame = contentFrame!.childFrames[0];

    JsHandle jsStreams = await childFrame.waitForFunction(
        "() => window.streams",
        timeout: Duration.zero,
        polling: Polling.interval(Duration(milliseconds: 100)));
    List streams = await jsStreams.jsonValue;

    List<Source> sources = [];
    for (Map stream in streams) {
      String name = stream["name"];
      Uri url = Uri.parse(stream["url"]);
      Source source = Source(name: name, url: url);
      sources.add(source);
    }
    BrowserConnection.disconnect();
    return sources;
  }

  @override
  String toString() {
    return "$name, $id-$slug";
  }
}
