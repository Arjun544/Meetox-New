// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

class UserModel {
  String? id;
  dynamic name;
  dynamic photo;
  bool? ispremium;
  dynamic location;
  dynamic socials;
  DateTime? createdAt;

  UserModel({
    this.id,
    this.name,
    this.photo,
    this.ispremium,
    this.location,
    this.socials,
    this.createdAt,
  });

  factory UserModel.fromRawJson(String str) =>
      UserModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        name: json["name"],
        photo: json["photo"],
        ispremium: json["ispremium"],
        location: json["location"],
        socials: json["socials"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "photo": photo,
        "ispremium": ispremium,
        "location": location,
        "socials": socials,
        "created_at": createdAt?.toIso8601String(),
      };
}
