String artistHelper(String artist, String format) {
  if (artist == '<unknown>') {
    return "Unknown Artist.$format";
  } else if (artist == '<unknown>' && format == '') {
return "Unknown artist";
  } else if (format == 'null') {
    return artist;
  } else {
    return "$artist.$format";
  }
}
