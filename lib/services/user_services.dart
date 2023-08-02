import 'dart:convert';
import 'dart:io';

import '../core/imports/core_imports.dart';
import '../models/user_model.dart';
import 'storage_services.dart';

class UserServices {
  static Future<UserModel> getCurrentUser() async {
    try {
      final data = await supabase
          .from('profiles')
          .select('*')
          .eq('id', supabase.auth.currentUser!.id)
          .single()
          .withConverter((data) {
        logError(jsonEncode(data));
        return UserModel.fromJSON(data);
      });

      return data;
    } catch (e) {
      logError(e.toString());
      rethrow;
    }
  }

  static Future<bool> addProfile(
      {required RxBool isLoading,
      required String name,
      required String dob,
      required File file}) async {
    try {
      isLoading(true);
      final photoUrl = await StorageServices.uploadImage(
        isLoading: isLoading,
        folder: 'circle profiles',
        subFolder: '${supabase.auth.currentUser!.id}/profile',
        file: file,
      );
      if (photoUrl.isNotEmpty) {
        await supabase.from('profiles').update({
          'name': name,
          'photo': photoUrl,
          'dob': dob,
        }).eq('id', supabase.auth.currentUser!.id);
      }
      isLoading(false);
      return true;
    } catch (e) {
      isLoading(false);
      logError(e.toString());
      rethrow;
    }
  }

  static Future<bool> updateLocation({
    required double lat,
    required double long,
    required String address,
  }) async {
    try {
      await supabase.from('profiles').update({
        'address': address,
        'location': LocationModel(
          latitude: lat,
          longitude: long,
        ).toJSON(),
      }).eq('id', supabase.auth.currentUser!.id);

      return true;
    } catch (e) {
      logError('Location ${e.toString()}');
      rethrow;
    }
  }

  static Future<List<UserModel>> getNearByUsers({
    required double lat,
    required double long,
    required double distanceInKm,
  }) async {
    try {
      final List<dynamic> data = await supabase.rpc(
        'nearby_users',
        params: {
          'lat': lat,
          'long': long,
          'distanceinkm': distanceInKm,
        },
      );
      logError(data.toString());

      final List<UserModel> users = data
          .map((e) => UserModel.fromJSON({
                'id': e['id'],
                'name': e['name'],
                'photo': e['photo'],
                'address': e['address'],
                'isPremium': e['ispremium'],
                'socials': e['socials'],
                'followers': e['followers'],
                'followings': e['followings'],
                'location': LocationModel.fromJSON(
                        jsonDecode(e['location']) as Map<String, dynamic>)
                    .toJSON(),
                'dob': e['dob'],
                'createdAt': e['created_at'],
              }))
          .toList();
      logError(users.length.toString());
      return users;

      // return List<UserModel>.from(jsonList.map((x) => UserModel.fromJSON(x)));
    } catch (e) {
      logError('Nearby Users ${e.toString()}');
      rethrow;
    }
  }
}
