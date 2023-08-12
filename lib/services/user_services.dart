import 'dart:convert';
import 'dart:io';

import '../core/imports/core_imports.dart';
import '../models/profile_model.dart';
import '../models/user_model.dart';
import 'storage_services.dart';

class UserServices {
  static Future<UserModel> userById({String? id}) async {
    try {
      final data = await supabase
          .from('profiles')
          .select(
            id == null
                ? 'id, name, photo, address, ispremium, location, socials'
                : 'id, name',
          )
          .eq('id', id ?? supabase.auth.currentUser!.id)
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

  static Future<ProfileModel> profileDetails(RxBool isLoading) async {
    try {
      isLoading(true);
      final profile = await supabase
          .rpc('profile_details')
          .withConverter((data) => ProfileModel.fromJson(data[0]));
      isLoading(false);
      return profile;
    } catch (e) {
      isLoading(false);
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
        await userById();
      }
      return true;
    } catch (e) {
      isLoading(false);
      logError(e.toString());
      showToast('Add profile failed');
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
      logError('Nearby Users ${data.toString()}');

      final List<UserModel> users = data
          .map((e) => UserModel.fromJSON({
                'id': e['id'],
                'name': e['name'],
                'photo': e['photo'],
                'address': e['address'],
                'isPremium': e['ispremium'],
                'followers': e['followers'],
                'followings': e['followings'],
                'location': LocationModel.fromJSON(
                        jsonDecode(e['location']) as Map<String, dynamic>)
                    .toJSON(),
                'dob': e['dob'],
                'created_at': e['created_at'],
              }))
          .toList();
      return users;
    } catch (e) {
      logError('Nearby Users ${e.toString()}');
      rethrow;
    }
  }

  static Future<List<Social>> getSocials({
    required String id,
    required RxBool isLoading,
  }) async {
    try {
      isLoading.value = true;
      final socials = await supabase
          .from('profiles')
          .select('socials')
          .eq('id', id)
          .limit(1)
          .single()
          .withConverter(
            (data) => List<Social>.from(
              data['socials'].map((x) => Social.fromJson(x)),
            ),
          );
      isLoading.value = false;
      logSuccess(socials.toString());
      return socials;
    } catch (e) {
      isLoading.value = false;
      logError(e.toString());
      rethrow;
    }
  }

  static Future<bool> addSocial(RxBool isLoading, Social social) async {
    try {
      isLoading.value = true;
      await supabase.from('profiles').update({
        'socials': [
          ...currentUser.value.socials!.map((e) => e.toJson()),
          social.toJson()
        ]
      }).eq('id', supabase.auth.currentUser!.id);
      isLoading.value = false;

      return true;
    } catch (e) {
      isLoading.value = false;
      showToast('Link failed to add');
      logError(e.toString());
      rethrow;
    }
  }

  static Future<bool> deleteSocial(RxBool isLoading, String type) async {
    try {
      isLoading.value = true;
      currentUser.value.socials!.removeWhere((e) => e.type == type);
      await supabase.from('profiles').update({
        'socials': currentUser.value.socials,
      }).eq('id', supabase.auth.currentUser!.id);
      isLoading.value = false;

      return true;
    } catch (e) {
      isLoading.value = false;
      showToast('Link failed to remove');
      logError(e.toString());
      rethrow;
    }
  }

  static Future<bool> updateDOB(RxBool isLoading, DateTime date) async {
    try {
      isLoading.value = true;
      await supabase.from('profiles').update({
        'dob': date.toIso8601String(),
      }).eq('id', supabase.auth.currentUser!.id);
      isLoading.value = false;

      return true;
    } catch (e) {
      isLoading.value = false;
      logError(e.toString());
      rethrow;
    }
  }
}
