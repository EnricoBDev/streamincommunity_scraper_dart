import 'package:http/http.dart' as http;

import 'movie.dart';
import 'tv_show.dart';
import 'dart:convert';
import 'constants.dart';
import 'watchable.dart';
import 'exceptions.dart';

/// Class that performes search queries to find tv shows or movies
class WatchableSearcher {
  /// Returns a list of [Watchable]
  ///
  /// Example:
  /// ```dart
  /// List<Watchable> watchables =
  ///          await WatchableSearcher.performQuery("NCIS - Unità anticrimine");
  /// ```
  static Future<List<Watchable>> performQuery(String query) async {
    final Uri searchUrl = Uri.parse("$API_URL/search?q=$query");
    http.Response response = await http.get(searchUrl);
    List searchResults = json.decode(response.body)["data"];
    if (searchResults.isEmpty) {
      throw NoResultsFoundException(
          cause: "No results were found, try with another query");
    }
    List<Watchable> watchables = [];
    for (Map result in searchResults) {
      Watchable watchable = _scrapeResult(result);
      watchables.add(watchable);
    }
    return watchables;
  }

  static Watchable _scrapeResult(Map result) {
    String type = result["type"];
    String name = result["name"];
    String slug = result["slug"];
    int id = result["id"];
    String url = "$BASE_URL/titles/$id-$slug";

    if (type == "tv") {
      int seasonsCount = result["seasons_count"];
      TvShow tvShow = TvShow(
          url: url, name: name, id: id, slug: slug, seasonsCount: seasonsCount);
      return tvShow;
    }
    Movie movie = Movie(url: url, name: name, id: id, slug: slug);
    return movie;
  }
}
