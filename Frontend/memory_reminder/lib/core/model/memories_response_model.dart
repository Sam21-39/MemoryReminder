// To parse this JSON data, do
//
//     final memoryResponse = memoryResponseFromJson(jsonString);

import 'dart:convert';

MemoryResponse memoryResponseFromJson(String str) =>
    MemoryResponse.fromJson(json.decode(str));

String memoryResponseToJson(MemoryResponse data) => json.encode(data.toJson());

class MemoryResponse {
  String? status;
  List<Memories>? result;
  String? error;

  MemoryResponse({
    this.status,
    this.result,
    this.error,
  });

  factory MemoryResponse.fromJson(Map<String, dynamic> json) => MemoryResponse(
        status: json["status"],
        result: json["result"] == null
            ? []
            : List<Memories>.from(
                json["result"]!.map((x) => Memories.fromJson(x))),
        error: json["error"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "result": result == null
            ? []
            : List<dynamic>.from(result!.map((x) => x.toJson())),
        "error": error,
      };
}

class Memories {
  String? id;
  String? title;
  String? content;
  String? userEmail;
  DateTime? eventDate;
  String? tag;
  String? image;
  DateTime? createdDate;
  DateTime? lastSentDate;
  int? v;

  Memories({
    this.id,
    this.title,
    this.content,
    this.userEmail,
    this.eventDate,
    this.tag,
    this.image,
    this.createdDate,
    this.lastSentDate,
    this.v,
  });

  factory Memories.fromJson(Map<String, dynamic> json) => Memories(
        id: json["_id"],
        title: json["title"],
        content: json["content"],
        userEmail: json["userEmail"],
        eventDate: json["eventDate"] == null
            ? null
            : DateTime.parse(json["eventDate"]),
        tag: json["tag"],
        image: json["image"],
        createdDate: json["createdDate"] == null
            ? null
            : DateTime.parse(json["createdDate"]),
        lastSentDate: json["lastSentDate"] == null
            ? null
            : DateTime.parse(json["lastSentDate"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "content": content,
        "userEmail": userEmail,
        "eventDate": eventDate?.toIso8601String(),
        "tag": tag,
        "image": image,
        "createdDate": createdDate?.toIso8601String(),
        "lastSentDate": lastSentDate?.toIso8601String(),
        "__v": v,
      };
}
