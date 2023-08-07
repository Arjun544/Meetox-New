// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

import 'dart:convert';

class ProfileModel {
  String? id;
  DateTime? dob;
  int? feeds;
  int? followers;
  int? followings;
  int? crosspaths;
  int? circles;
  int? questions;
  DateTime? createdAt;

  ProfileModel({
    this.id,
    this.dob,
    this.feeds,
    this.followers,
    this.followings,
    this.crosspaths,
    this.circles,
    this.questions,
    this.createdAt,
  });

  factory ProfileModel.fromRawJson(String str) =>
      ProfileModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        id: json["id"],
        dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
        feeds: json["feeds"],
        followers: json["followers"],
        followings: json["followings"],
        crosspaths: json["crosspaths"],
        circles: json["circles"],
        questions: json["questions"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "dob": dob?.toIso8601String(),
        "feeds": feeds,
        "followers": followers,
        "followings": followings,
        "crosspaths": crosspaths,
        "circles": circles,
        "questions": questions,
        "created_at": createdAt?.toIso8601String(),
      };
}
