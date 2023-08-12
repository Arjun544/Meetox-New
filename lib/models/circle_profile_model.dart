// To parse this JSON data, do
//
//     final circleModel = circleModelFromJson(jsonString);

import 'dart:convert';

import 'user_model.dart';

class CircleProfileModel {
  String? id;
  String? name;
  String? description;
  String? photo;
  String? address;
  int? limit;
  bool? isPrivate;
  UserModel? admin;
  DateTime? updatedAt;
  DateTime? createdAt;
  int? members;

  CircleProfileModel({
    this.id,
    this.name,
    this.description,
    this.photo,
    this.address,
    this.limit,
    this.isPrivate,
    this.admin,
    this.updatedAt,
    this.createdAt,
    this.members,
  });

  factory CircleProfileModel.fromRawJson(String str) =>
      CircleProfileModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CircleProfileModel.fromJson(Map<String, dynamic> json) =>
      CircleProfileModel(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        photo: json["photo"],
        address: json["address"],
        limit: json["limit"],
        isPrivate: json["isprivate"],
        admin: json["admin"] == null ? null : UserModel.fromJSON(json["admin"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        members: json["members"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "photo": photo,
        "address": address,
        "limit": limit,
        "isprivate": isPrivate,
        "admin": admin?.toJSON(),
        "updated_at": updatedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "members": members,
      };
}
