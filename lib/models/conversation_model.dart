import 'dart:convert';

import 'message_model.dart';

enum ConversationType {
  oneToOne,
  group,
}

class ConversationModel {
  String? id;
  String? circleId; // Only for group conversations
  ConversationType? type;
  DateTime? createdAt;
  MessageModel? lastMessage;
  List<String>? participants;

  ConversationModel({
    this.id,
    this.circleId,
    this.type,
    this.createdAt,
    this.lastMessage,
    this.participants,
  });

  factory ConversationModel.fromRawJson(String str) =>
      ConversationModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ConversationModel.fromJson(Map<String, dynamic> json) =>
      ConversationModel(
        id: json["id"],
        circleId: json["circle_id"],
        type: json["type"] == 'oneToOne'
            ? ConversationType.oneToOne
            : ConversationType.group,
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        lastMessage: json["lastMessage"] == null
            ? null
            : MessageModel.fromJson(json["lastMessage"]),
        participants: List<String>.from(
          json["allParticipants"].map(
            (x) => x['user_id'],
          ),
        ),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "circle_id": circleId,
        "type": type,
        "createdAt": createdAt,
        "lastMessage": lastMessage,
        "participants": participants,
      };
}
