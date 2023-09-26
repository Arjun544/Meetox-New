// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'dart:developer';

import 'package:flutter/scheduler.dart';
import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/models/conversation_model.dart';
import 'package:meetox/services/conversation_services.dart';
import 'package:meetox/services/message_services.dart';

import '../models/message_model.dart';

class ChatController extends GetxController {
  final RxString? id;
  final ConversationType? type;

  ChatController({this.id, this.type});

  ScrollController scrollController = ScrollController();
  final TextEditingController messageController = TextEditingController();
  final pagingController = PagingController<int, MessageModel>(
    firstPageKey: 1,
  );
  final RxBool isLoading = false.obs;
  final RxBool hasScrolledUp = false.obs;

  final messageInput = ''.obs;

  @override
  void onInit() {
    if (id != null) {
      pagingController.addPageRequestListener((pageKey) async {
        await fetchMessages(pageKey);
      });
    }
    scrollController = ScrollController()..addListener(scrollListener);

    // userNameSpace.on('onSendMessage', (data) {
    //   log('new Message: $data');
    //   final Message newMessage = Message.fromJson(data);
    //   pagingController.itemList!.insert(0, newMessage);
    //   pagingController.notifyListeners();
    //   scrollController.animateTo(
    //     0,
    //     duration: Duration(milliseconds: 300),
    //     curve: Curves.easeInOut,
    //   );
    // });

    super.onInit();
  }

  void scrollListener() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients &&
          scrollController.offset > 600 &&
          hasScrolledUp.value == false) {
        hasScrolledUp.value = true;
      } else if (hasScrolledUp.value == true &&
          scrollController.hasClients &&
          scrollController.offset < 1) {
        hasScrolledUp.value = false;
      }
    });
  }

  Future<void> fetchMessages(int pageKey) async {
    try {
      final List<MessageModel> newPage = await MessageServices.getMessages(
        id: id!.value,
        limit: pageKey,
      );

      final newItems = newPage;
      final hasNextPage = newPage.isEmpty;

      if (!hasNextPage) {
        pagingController.appendLastPage(newItems);
      } else if (hasNextPage) {
        pagingController.appendPage(newItems, pageKey + 1);
      }
    } catch (e) {
      log(e.toString());
      pagingController.error = e;
    }
  }

  void sendMessage(String userId) async {
    String? newConversationId;
    if (id!.value.isEmpty) {
      newConversationId = await ConversationServices.createConversation(
        conversation: ConversationModel(
          id: id!.value,
          type: type!,
          createdAt: DateTime.now(),
          lastMessage: MessageModel(
            content: messageController.text,
            type: MessageType.text,
            createdAt: DateTime.now(),
          ),
        ),
        participants: [
          currentUser.value.id!,
          userId,
        ],
      );
    }
    if (newConversationId != null) {
      await MessageServices.sendMessage(
        conversationId: newConversationId,
        message: MessageModel(
          content: messageController.text.trim(),
          type: MessageType.text,
          latitude: null,
          longitude: null,
          createdAt: DateTime.now(),
        ),
      );
    }
    messageController.clear();
  }

  @override
  void onClose() {
    scrollController.removeListener(scrollListener);
    messageController.dispose();
    pagingController.dispose();
    super.onClose();
  }
}
