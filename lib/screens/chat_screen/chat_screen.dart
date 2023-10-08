// ignore_for_file: unused_element, invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'dart:io';

import 'package:meetox/models/message_model.dart';
import 'package:meetox/widgets/unfocuser.dart';

import '../../controllers/chat_controller.dart';
import '../../core/imports/core_imports.dart';
import '../../core/imports/packages_imports.dart';
import '../../models/conversation_model.dart';
import '../../models/user_model.dart';
import '../../widgets/custom_error_widget.dart';
import '../../widgets/loaders/chat_loader.dart';
import 'components/chat_bubble.dart';
import 'components/chat_header.dart';
import 'components/message_input.dart';

class ChatScreen extends GetView<ChatController> {
  final ConversationModel conversation;
  final UserModel user;

  const ChatScreen({
    super.key,
    required this.conversation,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    Get.put(
      ChatController(
        id: conversation.id != null ? conversation.id!.obs : ''.obs,
        type: conversation.type,
      ),
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: Platform.isAndroid
          ? SystemUiOverlayStyle(
              statusBarColor: context.theme.indicatorColor,
              statusBarIconBrightness: context.theme.appBarTheme
                  .systemOverlayStyle!.statusBarIconBrightness,
            )
          : const SystemUiOverlayStyle(),
      child: UnFocuser(
        child: Scaffold(
          appBar: chatHeader(
            context,
            user,
          ),
          body: conversation.id == null
              ? Center(
                  child: CustomErrorWidget(
                    image: AssetsManager.sadState,
                    text: 'No messages',
                    isWarining: true,
                    onPressed: () {},
                  ),
                )
              : PagedListView(
                  pagingController: controller.pagingController,
                  reverse: true,
                  scrollController: controller.scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 15.sp),
                  builderDelegate: PagedChildBuilderDelegate<MessageModel>(
                    animateTransitions: true,
                    transitionDuration: const Duration(milliseconds: 500),
                    firstPageProgressIndicatorBuilder: (_) =>
                        const ChatLoader(),
                    newPageProgressIndicatorBuilder: (_) => const ChatLoader(),
                    firstPageErrorIndicatorBuilder: (_) => Center(
                      child: CustomErrorWidget(
                        image: AssetsManager.angryState,
                        text: 'Failed to fetch messages',
                        onPressed: () => controller.pagingController.refresh(),
                      ),
                    ),
                    newPageErrorIndicatorBuilder: (_) => Center(
                      child: CustomErrorWidget(
                        image: AssetsManager.angryState,
                        text: 'Failed to fetch messages',
                        onPressed: () => controller.pagingController.refresh(),
                      ),
                    ),
                    noItemsFoundIndicatorBuilder: (_) => CustomErrorWidget(
                      image: AssetsManager.sadState,
                      text: 'No messages',
                      onPressed: () => controller.pagingController.refresh(),
                    ),
                    itemBuilder: (context, item, index) {
                      return ChatBubble(
                        msg: item,
                      );
                    },
                  ),
                ),
          floatingActionButton: Obx(
            () => Visibility(
              visible: controller.hasScrolledUp.value,
              child: FloatingActionButton.small(
                elevation: 1,
                onPressed: () => controller.scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                ),
                backgroundColor: context.theme.backgroundColor,
                child: Icon(
                  FlutterRemix.arrow_down_s_fill,
                  color: context.theme.iconTheme.color,
                ),
              ),
            ),
          ),
          bottomNavigationBar: MessageInput(
            userId: user.id!,
          ),
        ),
      ),
    );
  }
}
