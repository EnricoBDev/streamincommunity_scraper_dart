import 'package:streamingcommunity_scraper/streamingcommunity_scraper.dart';

Future<void> main() async {
  // Search for a movie or tv show
  List<Watchable> watchables = await WatchableSearcher.performQuery("NCIS");

  // Select the one of the results
  Watchable watchable = watchables.first;

  if (watchable is TvShow) {
    // Select an episode and get the sources from which it is served
    List<Source> sources = await watchable.getSources(13, 24);

    // Get all the streams (video, audio and subtitles) from the source
    Map streams = await PlaylistParser()
        .setPlaylistSource(sources.first)
        .getMediaStreams();
  }
}
