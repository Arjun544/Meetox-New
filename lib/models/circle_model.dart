// To parse this JSON data, do
//
//     final circleModel = circleModelFromJson(jsonString);

import 'dart:convert';

import 'package:meetox/helpers/to_postgis_point.dart';

import 'user_model.dart';

class CircleModel {
  String? id;
  String? name;
  String? description;
  String? photo;
  String? address;
  int? limit;
  bool? isPrivate;
  LocationModel? location;
  String? adminId;
  DateTime? updatedAt;
  DateTime? createdAt;
  List<CircleMember>? circleMembers;

  CircleModel({
    this.id,
    this.name,
    this.description,
    this.photo,
    this.address,
    this.limit,
    this.isPrivate,
    this.location,
    this.adminId,
    this.updatedAt,
    this.createdAt,
    this.circleMembers,
  });

  factory CircleModel.fromRawJson(String str) =>
      CircleModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CircleModel.fromJson(Map<String, dynamic> json) => CircleModel(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        photo: json["photo"],
        address: json["address"],
        limit: json["limit"],
        isPrivate: json["isprivate"],
        location: json['location'] != null
            ? LocationModel.fromJSON(json['location'])
            : null,
        adminId: json["admin_id"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        circleMembers: json["circle_members"] == null
            ? []
            : List<CircleMember>.from(
                json["circle_members"]!.map((x) => CircleMember.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "photo": photo,
        "address": address,
        "limit": limit,
        "isprivate": isPrivate,
        if (location != null) 'location': toPostGISPoint(location),
        "admin_id": adminId,
        "updated_at": updatedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "circle_members": circleMembers == null
            ? []
            : List<dynamic>.from(circleMembers!.map((x) => x.toJson())),
      };
}

class CircleMember {
  int? count;

  CircleMember({
    this.count,
  });

  factory CircleMember.fromRawJson(String str) =>
      CircleMember.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CircleMember.fromJson(Map<String, dynamic> json) => CircleMember(
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "count": count,
      };
}
