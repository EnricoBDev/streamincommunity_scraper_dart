import 'package:streamingcommunity_scraper/src/constants.dart';
import 'package:streamingcommunity_scraper/src/movie.dart';
import 'package:streamingcommunity_scraper/src/source.dart';
import 'package:test/test.dart';

import 'constants.dart';

void main() {
  group("Movie tests", () {
    test("Test getSources() normal behaviour", () async {
      Movie movie = Movie(
          url: "$BASE_URL/26-hunger-games",
          name: "Hunger Games",
          id: 26,
          slug: "hunger-games",
          imageUrl: "$CDN_IMAGES/a79a9eb1-e1cb-4654-9b68-d0fdfdbd51ce.webpS");

      List<Source> sources = await movie.getSources();
      String firstUrl = sources.first.url.toString();

      expect(firstUrl, FIRST_EXPECTED_MOVIE_SOURCE_URL);
    });
  });
}
