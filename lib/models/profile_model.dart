// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

import 'dart:convert';

import 'package:meetox/models/user_model.dart';

class ProfileModel {
  String? id;
  String? name;
  String? address;
  bool? isPremium;
  int? followers;
  int? followings;
  List<Social>? socials;
  DateTime? dob;
  int? feeds;
  int? crosspaths;
  int? circles;
  int? questions;
  DateTime? createdAt;

  ProfileModel({
    this.id,
    this.name,
    this.address,
    this.isPremium,
    this.followers,
    this.followings,
    this.socials,
    this.dob,
    this.feeds,
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
        name: json["name"],
        address: json["address"],
        isPremium: json["ispremium"],
        followers: json["followers"] ?? 0,
        followings: json["followings"] ?? 0,
        socials: json["socials"] == null
            ? []
            : List<Social>.from(
                json["socials"].map((x) => Social.fromJson(x)),
              ),
        dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
        feeds: json["feeds"] ?? 0,
        crosspaths: json["crosspaths"] ?? 0,
        circles: json["circles"] ?? 0,
        questions: json["questions"] ?? 0,
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "address": address,
        "ispremium": isPremium,
        "followers": followers,
        "followings": followings,
        "socials": List<dynamic>.from(socials!.map((x) => x.toJson())),
        "dob": dob!.toIso8601String(),
        "feeds": feeds,
        "crosspaths": crosspaths,
        "circles": circles,
        "questions": questions,
        "created_at": createdAt!.toIso8601String(),
      };
}
