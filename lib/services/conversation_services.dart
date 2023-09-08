import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';

import '../models/conversation_model.dart';

class ConversationServices {
  // static Future<bool> hasConversation({
  //   required String senderId,
  //   required String receiverId,
  //   required RxBool isLoading,
  // }) async {
  //   try {
  //     isLoading(true);
  //     final PostgrestTransformBuilder data = await supabase
  //         .from('conversations')
  //         .select(
  //           'participants!user_id_fkey!inner(id)',
  //         )
  //         .or('follower_user_id.eq.$id,following_user_id.eq.$id')
  //         .eq('type', 'one_to_one')
  //         .eq('participants:user_id', senderId)
  //         .eq('participants:user_id', receiverId)
  //         .single();
  //     isLoading(false);

  //     logSuccess(data.toString());

  //     return false;
  //   } catch (e) {
  //     isLoading(false);

  //     logError(e.toString());
  //     rethrow;
  //   }
  // }

  static Future<List<ConversationModel>> getConversations({
    required int limit,
    String? query,
  }) async {
    try {
      final List<ConversationModel> conversations = query != null
          ? await supabase
              .from('participants')
              .select(
                'id, conversations(type)',
                const FetchOptions(
                  count: CountOption.exact,
                ),
              )
              .textSearch('fts', query)
              .eq('user_id', supabase.auth.currentUser!.id)
              .order('created_at')
              .limit(10 * limit)
              .withConverter(
                (data) => List<ConversationModel>.from(
                  data!.map((x) => ConversationModel.fromJson(x)),
                ),
              )
          : await supabase
              .from('participants')
              .select(
                'id, conversations(type)',
                const FetchOptions(
                  count: CountOption.exact,
                ),
              )
              .eq('user_id', supabase.auth.currentUser!.id)
              // .order('conversations.created_at', ascending: false)
              .limit(10 * limit)
              .withConverter(
                (data) => List<ConversationModel>.from(
                  data!.map((x) => ConversationModel.fromJson(x)),
                ),
              );
      return conversations;
    } catch (e) {
      logError('Get Conversations Error ${e.toString()}');
      rethrow;
    }
  }
}
