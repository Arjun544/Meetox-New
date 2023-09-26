import 'dart:developer';

import 'package:meetox/controllers/chat_controller.dart';
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

  static Future<String> createConversation({
    required ConversationModel conversation,
    required List<String> participants,
    String? groupId,
  }) async {
    try {
      final type =
          conversation.type == ConversationType.group ? 'group' : 'oneToOne';
      final newConversation = await supabase.from('conversations').insert({
        'type': type,
        'circle_id': type == 'group' ? groupId : null,
      }).select('id');
      final ChatController chatController = Get.find();
      chatController.id!(newConversation[0]['id']);
      log('new conversation id: ${newConversation.toString()}');
      // Add participants
      await supabase.from('participants').insert(participants
          .map(
            (participant) => {
              'conversation_id': newConversation[0]['id'],
              'user_id': participant
            },
          )
          .toList());
      return newConversation[0]['id'];
    } catch (e) {
      logError('Create Conversation Error ${e.toString()}');
      rethrow;
    }
  }

  static Future<List<ConversationModel>> getConversations({
    required int limit,
    String? query,
  }) async {
    try {
      final List<ConversationModel> conversations = query != null
          ? await supabase
              .from('conversations')
              .select(
                  'id, circle_id, type, participants(user_id), lastMessage:messages!conversations_last_message_fkey(id, content, type, latitude, longitude, created_at')
              .textSearch('fts', query)
              .eq('participants.user_id', supabase.auth.currentUser!.id)
              .order('created_at')
              .limit(10 * limit)
              .withConverter((data) {
              logSuccess(data.toString());

              return List<ConversationModel>.from(
                data!.map((x) => ConversationModel.fromJson(x)),
              );
            })
          : await supabase
              .from('conversations')
              .select(
                'id, circle_id, type, participants(user_id), allParticipants:participants(user_id), lastMessage:messages!conversations_last_message_fkey(id, content, type, latitude, longitude, sender_id, created_at)',
                const FetchOptions(
                  count: CountOption.exact,
                ),
              )
              .eq('participants.user_id', supabase.auth.currentUser!.id)
              // .order('conversations.created_at', ascending: false)
              .limit(10 * limit)
              .withConverter((data) {
              logSuccess(data.toString());

              return List<ConversationModel>.from(
                data!.map((x) => ConversationModel.fromJson(x)),
              );
            });
      return conversations;
    } catch (e) {
      logError('Get Conversations Error ${e.toString()}');
      rethrow;
    }
  }
}
