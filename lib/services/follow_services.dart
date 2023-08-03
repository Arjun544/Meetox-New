import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/models/user_model.dart';

class FollowServices {
  static Future<bool> isFollowed({required String targetUserId}) async {
    try {
      final data = await supabase
          .from('follow')
          .select()
          .eq('follower_user_id', targetUserId)
          .eq('following_user_id', supabase.auth.currentUser!.id);

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
          'follower_user_id': targetUserId,
          'following_user_id': supabase.auth.currentUser!.id,
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
}
