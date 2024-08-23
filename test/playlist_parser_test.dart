import 'package:test/test.dart';

import 'package:streamingcommunity_scraper/src/audio_stream.dart';
import 'package:streamingcommunity_scraper/src/media_stream.dart';
import 'package:streamingcommunity_scraper/src/playlist_parser.dart';
import 'package:streamingcommunity_scraper/src/source.dart';
import 'package:streamingcommunity_scraper/src/subtitles_stream.dart';
import 'package:streamingcommunity_scraper/src/video_stream.dart';

void main() {
  group("PlaylistParser tests", () {
    test("Test to check the normal behaviour of getMediaStreams() method",
        () async {
      Source testSource =
          Source(url: Uri.parse(r"https://vixcloud.co/playlist/196748?ub=1"));

      Map<String, List<MediaStream>> mediaStreams = await PlaylistParser()
          .setPlaylistSource(testSource)
          .getMediaStreams();

      Map<String, List<MediaStream>> expectedStreams = {
        "video": [
          VideoStream(
              url: Uri.parse(
                  "https://vixcloud.co/playlist/196748?type=video&rendition=480p&token=cathXj0jNDFEIxpJaBzW8Q&edge=sc-u8-01"),
              resolution: "854x480",
              codecs: ["avc1.640028", "mp4a.40.2"]),
          VideoStream(
              url: Uri.parse(
                  "https://vixcloud.co/playlist/196748?type=video&rendition=720p&token=ZZfmWNkcZHQhLf4lnZwOUg&edge=sc-u8-01"),
              resolution: "1280x720",
              codecs: ["avc1.640028", "mp4a.40.2"])
        ],
        "audio": [
          AudioStream(
              url: Uri.parse(
                  "https://vixcloud.co/playlist/196748?type=audio&rendition=ita&token=tXLs1kNj1O6MYhfYzKKaoQ&edge=sc-u8-01"),
              language: "Italian"),
          AudioStream(
              url: Uri.parse(
                  "https://vixcloud.co/playlist/196748?type=audio&rendition=eng&token=tXLs1kNj1O6MYhfYzKKaoQ&edge=sc-u8-01"),
              language: "English"),
        ],
        "subtitles": [
          SubtitlesStream(
              url: Uri.parse(
                  "https://vixcloud.co/playlist/196748?type=subtitle&rendition=3-eng&token=tXLs1kNj1O6MYhfYzKKaoQ&edge=sc-u8-01"),
              language: "English [CC]"),
          SubtitlesStream(
              url: Uri.parse(
                  "https://vixcloud.co/playlist/196748?type=subtitle&rendition=4-forced-ita&token=tXLs1kNj1O6MYhfYzKKaoQ&edge=sc-u8-01"),
              language: "Italian [Forced]"),
          SubtitlesStream(
              url: Uri.parse(
                  "https://vixcloud.co/playlist/196748?type=subtitle&rendition=5-ita&token=tXLs1kNj1O6MYhfYzKKaoQ&edge=sc-u8-01"),
              language: "Italian"),
        ]
      };
      expect(mediaStreams.toString(), expectedStreams.toString());
    });

    test(
        "Test to check correct functionality when resolution is expressed in bitrate",
        () async {
      Source testSource =
          Source(url: Uri.parse(r"https://vixcloud.co/playlist/45017?ab=1"));

      Map<String, List<MediaStream>> mediaStreams = await PlaylistParser()
          .setPlaylistSource(testSource)
          .getMediaStreams();

      Map<String, List<MediaStream>> expectedStreams = {
        "video": [
          VideoStream(
              url: Uri.parse(
                  "https://vixcloud.co/playlist/45017?type=video&rendition=720p&token=LN08jWPjftT9rcNBI59kuw&edge=sc-u4-01"),
              resolution: "3805 kbps",
              codecs: []),
          VideoStream(
              url: Uri.parse(
                  "https://vixcloud.co/playlist/45017?type=video&rendition=480p&token=zlvxd0096M9SviazePigAA&edge=sc-u4-01"),
              resolution: "2010 kbps",
              codecs: []),
        ],
        "audio": [],
        "subtitles": []
      };
      expect(mediaStreams.toString(), expectedStreams.toString());
    });
  });
}
