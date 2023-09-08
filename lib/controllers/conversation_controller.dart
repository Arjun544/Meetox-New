import 'dart:async';

import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/models/conversation_model.dart';
import 'package:meetox/services/conversation_services.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

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

  @override
  void dispose() {
    conversationsPagingController.dispose();
    super.dispose();
  }
}
