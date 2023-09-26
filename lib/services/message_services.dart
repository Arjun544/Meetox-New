import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/models/message_model.dart';

import '../core/imports/core_imports.dart';

class MessageServices {
  static Future<bool> sendMessage({
    required String conversationId,
    required MessageModel message,
  }) async {
    try {
      // Add new Message and lastMessage of conversation
      final newMessage = await supabase.from('messages').insert({
        'conversation_id': conversationId,
        'content': message.content,
        'sender_id': currentUser.value.id,
        'type': message.type == MessageType.text ? 'text' : 'location',
        'latitude': message.latitude,
        'longitude': message.longitude,
        'created_at': message.createdAt.toString(),
      }).select('id');
      // Add participants
      await supabase.from('conversations').update({
        'last_message': newMessage[0]['id'],
      }).eq(
        'id',
        conversationId,
      );

      return true;
    } catch (e) {
      logError('Send Messages Error ${e.toString()}');
      rethrow;
    }
  }

  static Future<List<MessageModel>> getMessages({
    required String id,
    required int limit,
    String? query,
  }) async {
    try {
      final List<MessageModel> messages = query != null
          ? await supabase
              .from('messages')
              .select(
                'id, content, type, latitude, longitude, created_at',
                const FetchOptions(
                  count: CountOption.exact,
                ),
              )
              .textSearch('fts', query)
              .eq('conversation_id', id)
              .order('created_at')
              .limit(10 * limit)
              .withConverter(
                (data) => List<MessageModel>.from(
                  data!.map((x) => MessageModel.fromJson(x)),
                ),
              )
          : await supabase
              .from('messages')
              .select(
                'id, content, type, latitude, longitude, created_at',
                const FetchOptions(
                  count: CountOption.exact,
                ),
              )
              .eq('conversation_id', supabase.auth.currentUser!.id)
              // .order('conversations.created_at', ascending: false)
              .limit(10 * limit)
              .withConverter(
                (data) => List<MessageModel>.from(
                  data!.map((x) => MessageModel.fromJson(x)),
                ),
              );
      return messages;
    } catch (e) {
      logError('Get Messages Error ${e.toString()}');
      rethrow;
    }
  }
}
