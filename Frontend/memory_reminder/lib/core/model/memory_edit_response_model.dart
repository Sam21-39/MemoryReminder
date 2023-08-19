// To parse this JSON data, do
//
//     final memoryEditRepsonse = memoryEditRepsonseFromJson(jsonString);

import 'dart:convert';

MemoryEditRepsonse memoryEditRepsonseFromJson(String str) =>
    MemoryEditRepsonse.fromJson(json.decode(str));

String memoryEditRepsonseToJson(MemoryEditRepsonse data) =>
    json.encode(data.toJson());

class MemoryEditRepsonse {
  String? status;

  MemoryEditRepsonse({
    this.status,
  });

  factory MemoryEditRepsonse.fromJson(Map<String, dynamic> json) =>
      MemoryEditRepsonse(
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
      };
}
