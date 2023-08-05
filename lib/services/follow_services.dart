import 'dart:convert';

import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/models/user_model.dart';

class FollowServices {
  static Future<bool> isFollowed({required String targetUserId}) async {
    try {
      final data = await supabase
          .from('follow')
          .select()
          .eq('following_user_id', supabase.auth.currentUser!.id)
          .eq('follower_user_id', targetUserId);

      logSuccess(data.toString());

      if (data.isEmpty) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      logError(e.toString());
      rethrow;
    }
  }

  static Future<bool> followUser(
      {required String targetUserId,
      required ValueNotifier<bool> isLoading}) async {
    try {
      isLoading.value = true;
      await supabase.from('follow').insert(
        {
          'follower_user_id': supabase.auth.currentUser!.id,
          'following_user_id': targetUserId,
        },
      );
      isLoading.value = false;
      logSuccess('followed user successfully');
      return true;
    } catch (e) {
      isLoading.value = false;
      logError(e.toString());
      rethrow;
    }
  }

  static Future<bool> unFollowUser(
      {required String targetUserId,
      required ValueNotifier<bool> isLoading}) async {
    try {
      isLoading.value = true;
      await supabase
          .from('follow')
          .delete()
          .eq('follower_user_id', targetUserId)
          .eq('following_user_id', supabase.auth.currentUser!.id);
      isLoading.value = false;
      logSuccess('unfollowed user successfully');

      return true;
    } catch (e) {
      isLoading.value = false;
      logError(e.toString());
      rethrow;
    }
  }

  static Future<List<UserModel>> getFollowers({
    required String id,
    required int limit,
    String? query,
  }) async {
    try {
      final followers = query != null
          ? await supabase
              .from('follow')
              .select(
                'profiles!follow_following_user_id_fkey!inner(id, name, photo, address)',
              )
              .textSearch('profiles.fts', query)
              .eq('follower_user_id', id)
              .limit(10 * limit)
              .withConverter((data) => List<UserModel>.from(
                    data!.map((x) => UserModel.fromJSON(x['profiles'])),
                  ))
          : await supabase
              .from('follow')
              .select(
                'profiles!follow_following_user_id_fkey!inner(id, name, photo, address)',
              )
              .eq('follower_user_id', id)
              .limit(10 * limit)
              .withConverter((data) => List<UserModel>.from(
                    data!.map((x) => UserModel.fromJSON(x['profiles'])),
                  ));

      return followers;
    } catch (e) {
      logError(e.toString());
      rethrow;
    }
  }

  static Future<List<UserModel>> getFollowings({
    required String id,
    required int limit,
    String? query,
  }) async {
    try {
      final followings = query != null
          ? await supabase
              .from('follow')
              .select(
                'profiles!follow_follower_user_id_fkey!inner(id, name, photo, address)',
              )
              .textSearch('profiles.fts', query)
              .eq('following_user_id', id)
              .limit(10 * limit)
              .withConverter((data) => List<UserModel>.from(
                    data!.map((x) => UserModel.fromJSON(x['profiles'])),
                  ))
          : await supabase
              .from('follow')
              .select(
                'profiles!follow_follower_user_id_fkey!inner(id, name, photo, address)',
              )
              .eq('following_user_id', id)
              .limit(10 * limit)
              .withConverter((data) => List<UserModel>.from(
                    data!.map((x) => UserModel.fromJSON(x['profiles'])),
                  ));

      return followings;
    } catch (e) {
      logError(e.toString());
      rethrow;
    }
  }

  static Future<List<UserModel>> getNearByFollowersFollowings({
    required double lat,
    required double long,
    required double distanceInKm,
  }) async {
    try {
      final List<dynamic> data = await supabase.rpc(
        'nearby_followers_followings',
        params: {
          'lat': lat,
          'long': long,
          'distanceinkm': distanceInKm,
        },
      );

      logError('Nearby Followers ${data.toString()}');

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

  static Future<List<UserModel>> getFollowersFollowings({
    required String id,
    required int limit,
    String? query,
  }) async {
    try {
      // TODO: Improve the logic in select
      final followers = query != null
          ? await supabase
              .from('follow')
              .select(
                'profiles!follow_follower_user_id_fkey!inner(id, name, photo, address)',
              )
              .textSearch('profiles.fts', query)
              .or('follower_user_id.eq.$id,following_user_id.eq.$id')
              .limit(10 * limit)
              .withConverter((data) => List<UserModel>.from(
                    data!.map((x) => UserModel.fromJSON(x['profiles'])),
                  ))
          : await supabase
              .from('follow')
              .select(
                'profiles!follow_follower_user_id_fkey!inner(id, name, photo, address)',
              )
              .or('follower_user_id.eq.$id,following_user_id.eq.$id')
              .limit(10 * limit)
              .withConverter(
                (data) => List<UserModel>.from(
                  data!.map((x) => UserModel.fromJSON(x['profiles'])),
                ),
              );

      return followers;
    } catch (e) {
      logError(e.toString());
      rethrow;
    }
  }
}
