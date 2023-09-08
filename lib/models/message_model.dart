import 'dart:convert';

enum MessageType {
  text,
  location,
}

class MessageModel {
  String? id;
  String? content;
  MessageType? type;
  double? latitude;
  double? longitude;
  DateTime? createdAt;

  MessageModel({
    this.id,
    this.content,
    this.type,
    this.latitude,
    this.longitude,
    this.createdAt,
  });

  factory MessageModel.fromRawJson(String str) =>
      MessageModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        id: json["id"],
        content: json["content"],
        type: json["type"],
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "content": content,
        "type": type,
        "latitude": latitude,
        "longitude": longitude,
        "createdAt": createdAt?.toIso8601String(),
      };
}
