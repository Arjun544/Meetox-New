import 'dart:convert';

import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/models/user_model.dart';

class FollowServices {
  static Future<bool> isFollowed({
    required String followerId,
    required String followingId,
    required RxBool isLoading,
  }) async {
    try {
      isLoading.value = true;
      final data = await supabase
          .from('follow')
          .select()
          .eq('follower_user_id', followerId)
          .eq('following_user_id', followingId);

      logSuccess(data.toString());
      isLoading.value = false;

      if (data.isEmpty) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      isLoading.value = false;
      logError(e.toString());
      rethrow;
    }
  }

  static Future<void> followUser({
    required String followerId,
    required String followingId,
    required void Function() onError,
  }) async {
    try {
      await supabase.from('follow').insert(
        {
          'follower_user_id': followerId,
          'following_user_id': followingId,
        },
      );
      logSuccess('followed user successfully');
    } catch (e) {
      onError();
      logError(e.toString());
      rethrow;
    }
  }

  static Future<void> unFollowUser({
    required String followerId,
    required String followingId,
    required void Function() onError,
  }) async {
    try {
      await supabase
          .from('follow')
          .delete()
          .eq('follower_user_id', followerId)
          .eq('following_user_id', followingId);
      logSuccess('unfollowed user successfully');
    } catch (e) {
      onError();
      logError(e.toString());
      rethrow;
    }
  }

  static Future<void> getFollowersCount({
    required String id,
    required void Function(int) onSuccess,
  }) async {
    try {
      final response = await supabase
          .from('follow')
          .select(
            'profiles!follow_following_user_id_fkey!inner(count)',
          )
          .eq('follower_user_id', id)
          .single();

      onSuccess(response['profiles']['count']);
    } catch (e) {
      logError(e.toString());
    }
  }

  static Future<void> getFollowingsCount({
    required String id,
    required void Function(int) onSuccess,
  }) async {
    try {
      final response = await supabase
          .from('follow')
          .select(
            'profiles!follow_follower_user_id_fkey!inner(count)',
          )
          .eq('following_user_id', id)
          .single();

      onSuccess(response['profiles']['count']);
    } catch (e) {
      logError(e.toString());
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
              .order('followed_at', ascending: false)
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
              .order('followed_at', ascending: false)
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
              .order('followed_at', ascending: false)
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
              .order('followed_at', ascending: false)
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
                'photo': e['photo'],
                'location': LocationModel.fromJSON(
                        jsonDecode(e['location']) as Map<String, dynamic>)
                    .toJSON(),
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
      final followers = query != null
          ? await supabase
              .from('follow')
              .select(
                'profiles!follow_follower_user_id_fkey!inner(id, name, photo, address, created_at, location)',
              )
              .textSearch('profiles.fts', query)
              .or('follower_user_id.eq.$id,following_user_id.eq.$id')
              .not('profiles.id', 'eq', id)
              .limit(10 * limit)
              .withConverter(
                (data) => List<UserModel>.from(
                  data!.map((x) => UserModel.fromJSON(x['profiles'])),
                ),
              )
          : await supabase
              .from('follow')
              .select(
                'profiles!follow_follower_user_id_fkey!inner(id, name, photo, address, created_at, location)',
              )
              .or('follower_user_id.eq.$id,following_user_id.eq.$id')
              .not('profiles.id', 'eq', id)
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
