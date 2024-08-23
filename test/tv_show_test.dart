import 'package:streamingcommunity_scraper/src/constants.dart';
import 'package:streamingcommunity_scraper/src/exceptions.dart';
import 'package:streamingcommunity_scraper/src/source.dart';
import 'package:streamingcommunity_scraper/src/tv_show.dart';
import 'package:test/test.dart';

import 'constants.dart';

void main() {
  group("TvShow tests", () {
    test("Test to check that getSources() works normally", () async {
      TvShow show = TvShow(
          url: "$BASE_URL/titles/7666-ncis-unita-anticrimine",
          name: "NCIS - Unità anticrimine",
          id: 7666,
          slug: "ncis-unita-anticrimine",
          seasonsCount: 20);
      List<Source> sources = await show.getSources(13, 24);
      String firstUrl = sources.first.url.toString();

      expect(firstUrl, FIRST_EXPECTED_TV_SHOW_SOURCE_URL);
    });

    test("Test to check SeasonNotExistentException", () {
      TvShow show = TvShow(
          url: "$BASE_URL/titles/2296-la-regina-degli-scacchi",
          name: "La regina degli scacchi",
          id: 2296,
          slug: "la-regina-degli-scacchi",
          seasonsCount: 1);
      expectLater(
          show.getSources(2, 1), throwsA(isA<SeasonNotExistentException>()));
    });

    test("Test to check EpisodeNotExistentException", () {
      TvShow show = TvShow(
          url: "$BASE_URL/titles/2296-la-regina-degli-scacchi",
          name: "La regina degli scacchi",
          id: 2296,
          slug: "la-regina-degli-scacchi",
          seasonsCount: 1);
      expectLater(
          show.getSources(1, 20), throwsA(isA<EpisodeNotExistentException>()));
    });
  });
}
