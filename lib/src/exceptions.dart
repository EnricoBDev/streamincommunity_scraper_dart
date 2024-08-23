class SeasonNotExistentException implements Exception {
  final String? cause;

  const SeasonNotExistentException({this.cause});
}

class ConnectionNotExistentException implements Exception {
  final String? cause;

  const ConnectionNotExistentException({this.cause});
}

class EpisodeNotExistentException implements Exception {
  final String? cause;

  const EpisodeNotExistentException({this.cause});
}

class NoResultsFoundException implements Exception {
  final String? cause;

  const NoResultsFoundException({this.cause});
}
