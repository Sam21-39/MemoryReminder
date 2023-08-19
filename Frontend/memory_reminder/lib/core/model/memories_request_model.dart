// To parse this JSON data, do
//
//     final memoryRequest = memoryRequestFromJson(jsonString);

import 'dart:convert';

MemoryRequest memoryRequestFromJson(String str) =>
    MemoryRequest.fromJson(json.decode(str));

String memoryRequestToJson(MemoryRequest data) => json.encode(data.toJson());

class MemoryRequest {
  String? title;
  String? content;
  String? userEmail;
  DateTime? eventDate;
  DateTime? lastSentDate;
  String? tag;
  String? image;

  MemoryRequest({
    this.title,
    this.content,
    this.userEmail,
    this.eventDate,
    this.lastSentDate,
    this.tag,
    this.image,
  });

  factory MemoryRequest.fromJson(Map<String, dynamic> json) => MemoryRequest(
        title: json["title"],
        content: json["content"],
        userEmail: json["userEmail"],
        eventDate: json["eventDate"] == null
            ? null
            : DateTime.parse(json["eventDate"]),
        lastSentDate: json["lastSentDate"] == null
            ? null
            : DateTime.parse(json["lastSentDate"]),
        tag: json["tag"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() {
    final map = {
      "title": title,
      "content": content,
      "userEmail": userEmail,
      "eventDate": eventDate?.toIso8601String(),
      "lastSentDate": lastSentDate?.toIso8601String(),
      "tag": tag,
      "image": image,
    };

    map.removeWhere((key, value) => value == null);

    return map;
  }
}
