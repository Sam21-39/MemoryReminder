class Methods {
  static String getDateFormat(DateTime time) {
    return '''${time.day.toString().padLeft(2, '0')}-${time.month.toString().padLeft(2, '0')}-${time.year} ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}''';
  }
}
