import 'dart:convert';

import 'message_model.dart';

enum ConversationType {
  oneToOne,
  group,
}

class ConversationModel {
  String? id;
  ConversationType? type;
  DateTime? createdAt;
  MessageModel? lastMessage;
  MetaData? metaData;

  ConversationModel({
    this.id,
    this.type,
    this.createdAt,
    this.lastMessage,
    this.metaData,
  });

  factory ConversationModel.fromRawJson(String str) =>
      ConversationModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ConversationModel.fromJson(Map<String, dynamic> json) =>
      ConversationModel(
        id: json["id"],
        type: json["type"],
        metaData: json["metaData"] == null
            ? null
            : MetaData.fromJson(json["metaData"]),
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        lastMessage: json["lastMessage"] == null
            ? null
            : MessageModel.fromJson(json["lastMessage"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "metaData": metaData == null ? null : metaData!.toJson(),
        "createdAt": createdAt,
        "lastMessage": lastMessage
      };
}

class MetaData {
  String? participant;
  bool? hasSeenLastMessage;
  String? id;

  MetaData({
    this.participant,
    this.hasSeenLastMessage,
    this.id,
  });

  factory MetaData.fromRawJson(String str) =>
      MetaData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MetaData.fromJson(Map<String, dynamic> json) => MetaData(
        participant: json["participant"],
        hasSeenLastMessage: json["hasSeenLastMessage"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "participant": participant!,
        "hasSeenLastMessage": hasSeenLastMessage,
        "_id": id,
      };
}
