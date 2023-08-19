// To parse this JSON data, do
//
//     final memoryAddRepsonse = memoryAddRepsonseFromJson(jsonString);

import 'dart:convert';

MemoryAddRepsonse memoryAddRepsonseFromJson(String str) =>
    MemoryAddRepsonse.fromJson(json.decode(str));

String memoryAddRepsonseToJson(MemoryAddRepsonse data) =>
    json.encode(data.toJson());

class MemoryAddRepsonse {
  String? status;
  String? message;

  MemoryAddRepsonse({
    this.status,
    this.message,
  });

  factory MemoryAddRepsonse.fromJson(Map<String, dynamic> json) =>
      MemoryAddRepsonse(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
