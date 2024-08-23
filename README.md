## Streamingcommunity scraper

Dart package to scrape Italian 🇮🇹 streaming website [streamingcommunity](streamincommunity.buzz)

## Features

- 🔍 Perform searches to find a movie or tv show
- 🎬 Get .m3u8 stream for video 🎞️, audio 🔈, and subtitles 📜

## Getting started

- The package depends on [puppeteer-dart](https://pub.dev/packages/puppeteer) 🃏 to connect to a remote chrome debugging instance, a pre-made Dockerfile 🐋 with all the necessary flags can be found [here](https://github.com/EnricoBDev/chrome-remote-debug-docker)

- Add to yout `pubspec.yaml`

```yaml
streamingcommunity_scraper:
  git:
    url: https://github.com/EnricoBDev/streamincommunity_scraper_dart.git
```

## Usage

```dart
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
```
