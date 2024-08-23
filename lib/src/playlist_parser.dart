import 'package:http/http.dart' as http;

import 'media_stream.dart';
import 'audio_stream.dart';
import 'subtitles_stream.dart';
import 'video_stream.dart';
import 'source.dart';

/// A parser for HLS playlists
/// example:
/// ``` dart
/// Map mediaStreams = PlaylistParser().setPlaylistSource(source).getMediaStreams();
/// ```
class PlaylistParser {
  Source? source;

  PlaylistParser setPlaylistSource(Source source) {
    this.source = source;
    return this;
  }

  /// Parser method for video tracks
  Future<List<VideoStream>> getVideoTracks() async {
    String playlistBody;
    try {
      playlistBody = await _getPlaylistBody();
    } on http.ClientException {
      rethrow;
    }

    List<String> lines = playlistBody.split("\n");
    RegExp videoPattern = RegExp("#EXT-X-STREAM");

    List<VideoStream> videoTracks = [];
    for (String line in lines) {
      if (videoPattern.hasMatch(line)) {
        RegExp codecsPattern = RegExp('(?<=CODECS=")(.*?)(?=",)');
        RegExp resolutionPattern = RegExp("(?<=RESOLUTION=)(.*?)(?=,)");
        RegExp bitratePattern = RegExp(r'(?<=BANDWIDTH=)(.*?)$');

        Uri url = Uri.parse(lines[lines.indexOf(line) + 1]);

        String resolution;
        if (resolutionPattern.firstMatch(line) != null) {
          resolution = resolutionPattern.firstMatch(line)!.group(0)!;
        } else {
          int bitrate = int.parse(bitratePattern.firstMatch(line)!.group(0)!);
          resolution = "${bitrate ~/ 1000} kbps";
        }

        List<String> codecs;
        if (codecsPattern.firstMatch(line) != null) {
          String codecsString = codecsPattern.firstMatch(line)!.group(0)!;
          codecs = codecsString.split(",");
        } else {
          codecs = [];
        }

        VideoStream videoTrack =
            VideoStream(url: url, resolution: resolution, codecs: codecs);
        videoTracks.add(videoTrack);
      }
    }

    return videoTracks;
  }

  /// Parser method for audio tracks
  Future<List<AudioStream>> getAudioTracks() async {
    String playlistBody;
    try {
      playlistBody = await _getPlaylistBody();
    } on http.ClientException {
      rethrow;
    }

    List<String> lines = playlistBody.split("\n");
    RegExp audioPattern = RegExp("#EXT-X-MEDIA:TYPE=AUDIO");

    List<AudioStream> audioTracks = [];
    for (String line in lines) {
      if (audioPattern.hasMatch(line)) {
        RegExp languagePattern = RegExp('(?<=NAME=")(.*?)(?=")');
        RegExp urlPattern = RegExp('(?<=URI=")(.*?)(?=")');

        Uri url = Uri.parse(urlPattern.firstMatch(line)!.group(0)!);
        String language = languagePattern.firstMatch(line)!.group(0)!;

        AudioStream audioTrack = AudioStream(url: url, language: language);
        audioTracks.add(audioTrack);
      }
    }
    return audioTracks;
  }

  /// Parser method for subtitles
  Future<List<SubtitlesStream>> getSubtitles() async {
    String playlistBody;
    try {
      playlistBody = await _getPlaylistBody();
    } on http.ClientException {
      rethrow;
    }

    List<String> lines = playlistBody.split("\n");
    RegExp subtitlePattern = RegExp("#EXT-X-MEDIA:TYPE=SUBTITLES");

    List<SubtitlesStream> subtitles = [];
    for (String line in lines) {
      if (subtitlePattern.hasMatch(line)) {
        RegExp languagePattern = RegExp('(?<=NAME=")(.*?)(?=")');
        RegExp urlPattern = RegExp('(?<=URI=")(.*?)(?=")');

        Uri url = Uri.parse(urlPattern.firstMatch(line)!.group(0)!);
        String language = languagePattern.firstMatch(line)!.group(0)!;

        SubtitlesStream subtitle =
            SubtitlesStream(url: url, language: language);
        subtitles.add(subtitle);
      }
    }
    return subtitles;
  }

  /// Parser method that returns a map with the following keys:
  /// - "video" for video tracks
  /// - "audio" for audio tracks
  /// - "subtitles" for subtitles
  Future<Map<String, List<MediaStream>>> getMediaStreams() async {
    return {
      "video": await getVideoTracks(),
      "audio": await getAudioTracks(),
      "subtitles": await getSubtitles()
    };
  }

  Future<String> _getPlaylistBody() async {
    Uri playlistUrl = source!.url;
    try {
      http.Response response = await http.get(playlistUrl);
      return response.body;
    } on http.ClientException {
      rethrow;
    }
  }
}
