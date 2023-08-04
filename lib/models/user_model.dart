import 'dart:convert';

import '../helpers/to_postgis_point.dart';

class UserModel {
  String? id;
  String? name;
  String? photo;
  String? address;
  bool? isPremium;
  int? followers;
  int? followings;
  List<Social>? socials;
  LocationModel? location;
  DateTime? dob;
  DateTime? createdAt;

  UserModel({
    this.id,
    this.name,
    this.photo,
    this.address,
    this.isPremium,
    this.followers,
    this.followings,
    this.socials,
    this.location,
    this.dob,
    this.createdAt,
  });

  factory UserModel.fromJSON(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      photo: json['photo'],
      address: json['address'],
      isPremium: json['ispremium'],
      socials: json["socials"] == null
          ? null
          : List<Social>.from(json["socials"]!.map((x) => Social.fromJson(x))),
      followers: json['followers'] ?? 0,
      followings: json['followings'] ?? 0,
      location: json['location'] != null
          ? LocationModel.fromJSON(json['location'])
          : null,
      dob: json['dob'] != null ? DateTime.parse(json['dob']) : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (photo != null) 'photo': photo,
      if (address != null) 'address': address,
      if (isPremium != null) 'ispremium': isPremium,
      if (socials != null)
        'socials': List<Social>.from(socials!.map((x) => x.toJson())),
      if (followers != null) 'followers': followers,
      if (followings != null) 'followings': followings,
      if (location != null) 'location': toPostGISPoint(location),
      if (dob != null) 'dob': dob!.toUtc().toIso8601String(),
      if (createdAt != null) 'created_at': createdAt!.toUtc().toIso8601String(),
    };
  }
}

class LocationModel {
  double? longitude;
  double? latitude;

  LocationModel({
    this.longitude,
    this.latitude,
  });

  factory LocationModel.fromJSON(Map<String, dynamic>? json) {
    if (json == null) return LocationModel();

    return LocationModel(
      longitude: json['coordinates'][0],
      latitude: json['coordinates'][1],
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      if (longitude != null && latitude != null) 'type': 'Point',
      'coordinates': [longitude!, latitude!],
    };
  }
}

class Social {
  String? type;
  String? url;

  Social({
    this.type,
    this.url,
  });

  factory Social.fromRawJson(String str) => Social.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Social.fromJson(Map<String, dynamic> json) => Social(
        type: json["type"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "url": url,
      };
}
