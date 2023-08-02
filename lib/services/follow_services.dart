import 'package:meetox/core/imports/core_imports.dart';

class FollowServices {
  static Future<bool> isFollowed({required String targetUserId}) async {
    try {
      final data = await supabase
          .from('follow')
          .select()
          .eq('follower_user_id', supabase.auth.currentUser!.id)
          .eq('following_user_id', targetUserId);

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

  static Future<bool> followUser({required String targetUserId}) async {
    try {
      await supabase.from('follow').insert(
        {
          'follower_user_id': supabase.auth.currentUser!.id,
          'following_user_id': targetUserId,
        },
      );
      logSuccess('followed user successfully');
      return true;
    } catch (e) {
      logError(e.toString());
      rethrow;
    }
  }

  static Future<bool> unFollowUser({required String targetUserId}) async {
    try {
      await supabase
          .from('follow')
          .delete()
          .eq('follower_user_id', supabase.auth.currentUser!.id)
          .eq('following_user_id', targetUserId);
      logSuccess('unfollowed user successfully');
      return true;
    } catch (e) {
      logError(e.toString());
      rethrow;
    }
  }
}
