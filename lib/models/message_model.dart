import 'dart:convert';

enum MessageType {
  text,
  location,
}

class MessageModel {
  String? id;
  String? content;
  String? senderId;
  MessageType? type;
  double? latitude;
  double? longitude;
  DateTime? createdAt;

  MessageModel({
    this.id,
    this.content,
    this.senderId,
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
        senderId: json["sender_id"],
        type: json["type"] == 'text' ? MessageType.text : MessageType.location,
        latitude: json["latitude"] == null ? 0 : json["latitude"].toDouble(),
        longitude: json["longitude"] == null ? 0 : json["longitude"].toDouble(),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "content": content,
        "sender_id": senderId,
        "type": type,
        "latitude": latitude,
        "longitude": longitude,
        "createdAt": createdAt?.toIso8601String(),
      };
}
