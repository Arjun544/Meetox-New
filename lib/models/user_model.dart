// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';

class User {
  User({
    this.location,
    this.id,
    this.name,
    this.email,
    this.displayPic,
    this.isPremium,
    this.createdAt,
  });

  factory User.fromRawJson(String str) => User.fromJson(
        json.decode(str) as Map<String, dynamic>,
      );

  factory User.fromJson(Map<String, dynamic> json) => User(
        location: json['location'] == null
            ? null
            : Location.fromJson(
                json['location'] as Map<String, dynamic>,
              ),
        id: json['id'] as String,
        name: json['name'] as String,
        email: json['email'] as String,
        displayPic: json['display_pic'] == null
            ? null
            : DisplayPic.fromJson(json['display_pic'] as Map<String, dynamic>),
        isPremium: json['isPremium'] as bool,
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
      );
  Location? location;
  String? id;
  String? name;
  String? email;
  DisplayPic? displayPic;
  bool? isPremium;
  DateTime? createdAt;

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        'location': location?.toJson(),
        'id': id,
        'name': name,
        'email': email,
        'display_pic': displayPic?.toJson(),
        'isPremium': isPremium,
        'createdAt': createdAt?.toIso8601String(),
      };
}

class DisplayPic {
  DisplayPic({
    this.profile,
    this.profileId,
  });

  factory DisplayPic.fromRawJson(String str) => DisplayPic.fromJson(
        json.decode(str) as Map<String, dynamic>,
      );

  factory DisplayPic.fromJson(Map<String, dynamic> json) => DisplayPic(
        profile: json['profile'] as String,
        profileId: json['profileId'] as String,
      );
  String? profile;
  String? profileId;

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        'profile': profile,
        'profileId': profileId,
      };
}

class Location {
  Location({
    this.address,
    this.coordinates,
  });

  factory Location.fromRawJson(String str) =>
      Location.fromJson(json.decode(str) as Map<String, dynamic>);

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        address: json['address'] as String,
        coordinates: json['coordinates'] == null
            ? []
            : List<double>.from(
                json['coordinates']!.map((double x) => x).toList()
                    as List<dynamic>,
              ),
      );
  String? address;
  List<double>? coordinates;

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        'address': address,
        'coordinates': coordinates == null
            ? []
            : List<dynamic>.from(coordinates!.map((x) => x)),
      };
}

class SocialModel {
  List<Social>? socials;

  SocialModel({
    this.socials,
  });

  factory SocialModel.fromRawJson(String str) =>
      SocialModel.fromJson(json.decode(str) as Map<String, dynamic>);

  String toRawJson() => json.encode(toJson());

  factory SocialModel.fromJson(Map<String, dynamic> json) => SocialModel(
        socials: json["socials"] == null
            ? []
            : List<Social>.from(
                json["socials"]!.map((x) => Social.fromJson(x)),
              ).toList(),
      );

  Map<String, dynamic> toJson() => {
        "socials": socials == null
            ? []
            : List<dynamic>.from(socials!.map((x) => x.toJson())),
      };
}

class Social {
  String? name;
  String? url;

  Social({
    this.name,
    this.url,
  });

  factory Social.fromRawJson(String str) => Social.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Social.fromJson(Map<String, dynamic> json) => Social(
        name: json["name"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "url": url,
      };
}
