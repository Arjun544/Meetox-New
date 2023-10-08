import 'dart:async';

import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/models/conversation_model.dart';
import 'package:meetox/models/message_model.dart';
import 'package:meetox/services/conversation_services.dart';

class ConversationController extends GetxController {
  final conversationsPagingController =
      PagingController<int, ConversationModel>(firstPageKey: 1);

  final RxString searchQuery = ''.obs;
  late Worker searchDebounce;

  @override
  void onInit() {
    super.onInit();
    conversationsPagingController.addPageRequestListener((page) async {
      await fetchConversations(page);
      searchDebounce = debounce(
        searchQuery,
        (value) {
          conversationsPagingController.refresh();
        },
        time: const Duration(seconds: 2),
      );
    });
    listenConversations();
  }

  Future<void> fetchConversations(int pageKey) async {
    try {
      final newPage = await ConversationServices.getConversations(
        limit: pageKey,
        query: searchQuery.value.isEmpty ? null : searchQuery.value,
      );

      final newItems = newPage;
      final hasNextPage = newPage.isEmpty;

      if (!hasNextPage) {
        conversationsPagingController.appendLastPage(newItems);
      } else if (hasNextPage) {
        conversationsPagingController.appendPage(newItems, pageKey + 1);
      }
    } catch (e) {
      logError(e.toString());
      conversationsPagingController.error = e;
    }
  }

  void listenConversations() async {
    supabase.channel('public:conversations').on(
      RealtimeListenTypes.postgresChanges,
      ChannelFilter(event: 'INSERT', schema: 'public', table: 'conversations'),
      (payload, [ref]) async {
        final conversationIds = await supabase
            .from('conversations')
            .select<List<dynamic>>(
              'id, participants(user_id), allParticipants:participants(user_id)',
            )
            .eq('participants.user_id', supabase.auth.currentUser!.id);
        logSuccess('new conversation received: $conversationIds');
        final ids = conversationIds.map((e) => e['id']).toList();
        final List<String> participants = conversationIds
            .map((e) => e['allParticipants'].toString())
            .toList();
        logSuccess('ids received: $ids');
        logSuccess('participants received: $participants');

        if (ids.contains(payload['new']['id'])) {
          final PostgrestMap updatedConversaion = await supabase
              .from('conversations')
              .select(
                'lastMessage:messages!conversations_last_message_fkey(id, content, type, latitude, longitude, sender_id, created_at)',
              )
              .eq('id', payload['new']['id'])
              .single();
          logError('updatedConversaion: ${updatedConversaion['lastMessage']}');
          final ConversationModel newConversation = ConversationModel(
            id: payload['new']['id'],
            type: payload['new']['type'] == 'oneToOne'
                ? ConversationType.oneToOne
                : ConversationType.group,
            createdAt: DateTime.parse(payload['new']['created_at']),
            lastMessage:
                MessageModel.fromJson(updatedConversaion['lastMessage']),
            participants: participants,
          );
          conversationsPagingController.itemList!.insert(0, newConversation);
          // conversationsPagingController.notifyListeners();
        }
      },
    ).subscribe();
  }

  @override
  void dispose() {
    conversationsPagingController.dispose();
    super.dispose();
  }
}
