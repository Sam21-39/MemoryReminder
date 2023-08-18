class Methods {
  static String getDateFormat(DateTime time) {
    return '${time.day}-${time.month}-${time.year} ${time.hour}:${time.minute}:${time.second}';
  }
}
