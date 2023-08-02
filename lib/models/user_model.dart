import '../helpers/to_postgis_point.dart';

class UserModel {
  String? id;
  String? name;
  String? photo;
  String? address;
  bool? isPremium;
  int? followers;
  int? followings;
  Map<String, dynamic>? socials;
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
      socials: json['socials'],
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
      if (socials != null) 'socials': socials,
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
