import '../helpers/to_postgis_point.dart';

class UserModel {
  String? id;
  String? name;
  String? photo;
  bool? isPremium;
  Map<String, dynamic>? socials;
  Location? location;
  DateTime? dob;
  DateTime? createdAt;

  UserModel({
    this.id,
    this.name,
    this.photo,
    this.isPremium,
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
      isPremium: json['ispremium'],
      socials: json['socials'],
      location:
          json['location'] != null ? Location.fromJSON(json['location']) : null,
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
      if (isPremium != null) 'ispremium': isPremium,
      if (socials != null) 'socials': socials,
      if (location != null) 'location': toPostGISPoint(location),
      if (dob != null) 'dob': dob!.toUtc().toIso8601String(),
      if (createdAt != null) 'created_at': createdAt!.toUtc().toIso8601String(),
    };
  }
}

class Location {
  double? longitude;
  double? latitude;

  Location({
    this.longitude,
    this.latitude,
  });

  factory Location.fromJSON(Map<String, dynamic>? json) {
    if (json == null) return Location();

    return Location(
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
