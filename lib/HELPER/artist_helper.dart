String artistHelper(String artist, String format) {
  if (artist == '<unknown>') {
    return "Unknown Artist.$format";
  } else if (format == 'null') {
    return artist;
  } else {
    return "$artist.$format";
  }
}
