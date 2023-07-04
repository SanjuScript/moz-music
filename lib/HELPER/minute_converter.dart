class ToMinutes {
  static String stringParseToMinuteSeconds(int ms) {
    String dataaa;
    Duration duration = Duration(milliseconds: ms);
    int minutes = duration.inMinutes;
    int seconds = (duration.inSeconds) - (minutes * 60);
    dataaa = "$minutes:";
    if (seconds <= 9) dataaa += '0';
    dataaa += seconds.toString();
    return dataaa;
  }

  static double doubleParseToMinuteSeconds(int ms) {
    Duration duration = Duration(milliseconds: ms);
    int minutes = duration.inMinutes;
    int seconds = (duration.inSeconds) - (minutes * 60);
    double result = minutes + (seconds / 60);
    return result;
  }


}