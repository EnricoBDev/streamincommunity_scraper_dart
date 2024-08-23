import 'package:streamingcommunity_scraper/src/exceptions.dart';
import 'package:streamingcommunity_scraper/src/watchable.dart';
import 'package:streamingcommunity_scraper/src/watchable_searcher.dart';
import 'package:test/test.dart';

void main() {
  group('WatchableSearcher tests', () {
    test(
      "Test for query that returns both TvShow and Movie",
      () async {
        List<Watchable> watchables =
            await WatchableSearcher.performQuery("puffi");
        List<String> watchablesToString = [];
        for (var watchable in watchables) {
          watchablesToString.add(watchable.toString());
        }

        const List<String> expectedWatchablesToString = [
          "I Puffi - Viaggio nella foresta segreta, 5495-i-puffi-viaggio-nella-foresta-segreta",
          "I Puffi 2, 1981-i-puffi-2",
          "I Puffi, 1980-i-puffi",
          "I Puffi, 2 s, 9029-i-puffi"
        ];

        expect(watchablesToString, expectedWatchablesToString);
      },
    );

    test("Test for no results", () async {
      expectLater(WatchableSearcher.performQuery("qwerty"),
          throwsA(isA<NoResultsFoundException>()));
    });
  });
}
