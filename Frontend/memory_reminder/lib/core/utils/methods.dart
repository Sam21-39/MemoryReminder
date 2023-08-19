import 'dart:convert';
import 'dart:io';

class Methods {
  static String getDateFormat(DateTime time) {
    return '''${time.day.toString().padLeft(2, '0')}-${time.month.toString().padLeft(2, '0')}-${time.year} ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}''';
  }

  static Future<String> imageToBase64Conversion(File imageFile) async {
    List<int> imageBytes = await File(imageFile.path).readAsBytes();
    // print(imageBytes);
    String base64Image = base64Encode(imageBytes);
    return base64Image;
  }
}
