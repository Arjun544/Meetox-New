// To parse this JSON data, do
//
//     final circleModel = circleModelFromJson(jsonString);

import 'dart:convert';

import 'package:meetox/helpers/to_postgis_point.dart';

import 'user_model.dart';

class CircleModel {
  String? id;
  String? name;
  String? photo;
  int? members;
  String? adminId;
  LocationModel? location;

  CircleModel({
    this.id,
    this.name,
    this.photo,
    this.members,
    this.adminId,
    this.location,
  });

  factory CircleModel.fromRawJson(String str) =>
      CircleModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CircleModel.fromJson(Map<String, dynamic> json) => CircleModel(
        id: json["id"],
        name: json["name"],
        photo: json["photo"],
        members: json["members"].runtimeType == List
            ? json["members"][0]['count'] as int
            : json["members"],
        adminId: json["admin_id"],
        location: json['location'] != null
            ? LocationModel.fromJSON(json['location'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "photo": photo,
        "members": members,
        "admin_id": adminId,
        if (location != null) 'location': toPostGISPoint(location),
      };
}
