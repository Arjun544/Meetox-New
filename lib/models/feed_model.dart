// To parse this JSON data, do
//
//     final circleModel = circleModelFromJson(jsonString);

import 'dart:convert';

import 'package:meetox/helpers/to_postgis_point.dart';

import 'user_model.dart';

class FeedModel {
  String? id;
  String? content;
  List<String>? images;
  String? address;
  int? likes;
  int? comments;
  UserModel? admin;
  LocationModel? location;
  DateTime? createdAt;

  FeedModel({
    this.id,
    this.content,
    this.images,
    this.address,
    this.likes,
    this.comments,
    this.admin,
    this.location,
    this.createdAt,
  });

  factory FeedModel.fromRawJson(String str) =>
      FeedModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FeedModel.fromJson(Map<String, dynamic> json) => FeedModel(
        id: json["id"],
        content: json["content"],
        images: json["images"] ?? [],
        address: json["address"],
        likes: json["likes"],
        comments: json["comments"],
        admin: json["user_id"] == null ? null : UserModel.fromJSON(json["user_id"]),
        location: json['location'] != null
            ? LocationModel.fromJSON(json['location'])
            : null,
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "content": content,
        "images": images,
        "address": address,
        "likes": likes,
        "comments": comments,
        "user_id": admin?.toJSON(),
        if (location != null) 'location': toPostGISPoint(location),
        "created_at": createdAt?.toIso8601String(),
      };
}
