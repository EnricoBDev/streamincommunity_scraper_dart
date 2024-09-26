import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:puppeteer/puppeteer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'browser_connection.dart';
import 'constants.dart';
import 'exceptions.dart';
import 'source.dart';
import 'watchable.dart';

/// A class that represents a tv show and its details
class TvShow extends Watchable {
  final int seasonsCount;

  //TODO: create named constructor that also gets other media details like a description
  const TvShow(
      {required super.url,
      required super.name,
      required super.id,
      required super.slug,
      required super.imageUrl,
      required this.seasonsCount});

  Uri _getSeasonTabUri(int seasonId) {
    if (seasonId <= seasonsCount && seasonsCount >= 1) {
      return Uri.parse("$url/stagione-$seasonId");
    } else {
      throw SeasonNotExistentException(
          cause: "seasonId not in list of exsisting seasons for $name");
    }
  }

  /// Gets the sources that serve the episode of this tv show, takes:
  /// - [seasonId] the season number
  /// - [episode] the episode number
  /// If [seasonId] or [episode] are out of range, exceptions are thrown
  ///
  /// Example:
  /// ```dart
  /// TvShow show = TvShow(
  ///        url: "$BASE_URL/titles/7666-ncis-unita-anticrimine",
  ///        name: "NCIS - Unità anticrimine",
  ///        id: 7666,
  ///        slug: "ncis-unita-anticrimine",
  ///        seasonsCount: 20);
  ///    List<Source> sources = await show.getSources(13, 24);
  /// ```
  Future<List<Source>> getSources(int seasonId, int episode) async {
    Map mediaDetails = await _getMediaDetails(_getSeasonTabUri(seasonId));

    List episodes = _getEpisodes(mediaDetails);
    int maxEpisode = episodes.length;
    if (episode > maxEpisode) {
      throw EpisodeNotExistentException(
          cause: "The episode with number $episode is not in this season");
    }

    int episodeId = _getEpisodeId(episodes, episode);
    String iframeUrl = _buildIframeUrl(episodeId);

    Browser? browser = await BrowserConnection.getBrowser(SERVER_URL);
    Page page = await browser!.newPage();

    await page.goto(iframeUrl, wait: Until.networkIdle, timeout: Duration.zero);

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
      Source source = Source(name: name, url: url, fileName: this.name);
      sources.add(source);
    }
    BrowserConnection.disconnect();
    return sources;
  }

  Future<Map> _getMediaDetails(Uri url) async {
    http.Response response = await http.get(url);
    String body = response.body;

    BeautifulSoup bs4 = BeautifulSoup(body);
    String? dataPage = bs4.find("div", id: "app")![
        "data-page"]; // [] operator gets the attribute ["data-page"]
    Map details = json.decode(dataPage!)["props"];
    return details;
  }

  List _getEpisodes(Map mediaDetails) {
    return mediaDetails["loadedSeason"]["episodes"];
  }

  int _getEpisodeId(List episodes, int number) {
    return episodes[number - 1]["id"];
  }

  String _buildIframeUrl(int episodeId) {
    return "$BASE_URL/iframe/$id?episode_id=$episodeId&next_episode=1";
  }

  @override
  String toString() {
    return "$name, $seasonsCount s, $id-$slug";
  }
}
