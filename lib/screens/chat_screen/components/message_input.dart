// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:meetox/controllers/chat_controller.dart';
import 'package:meetox/models/message_model.dart';

import '../../../core/imports/core_imports.dart';
import '../../../core/imports/packages_imports.dart';

class MessageInput extends GetView<ChatController> {
  final String userId;

  const MessageInput({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    Future sendMessage(String msg) async {
      if (controller.id != null) {
        final msgObject = MessageModel(
          content: msg,
          latitude: 0,
          longitude: 0,
          type: MessageType.text,
          createdAt: DateTime.now(),
        );

        // await sendMessageMutation.mutateAsync({
        //   'msg': msgObject,
        //   'id': conversationController.currentConversationId.value,
        // });

        // if (sendMessageMutation.hasError) {
        //   log('mutation error: ${sendMessageMutation.error}');
        //   sendMessageMutation.reset();
        // } else if (sendMessageMutation.hasData) {
        //   // // Set data back to original
        //   controller.messageController.clear();
        //   controller.messageInput.value = '';
        // }
      } else {
        // final msgObject = Message(
        //   id: getDocId(16),
        //   senderId: currentUser.value,
        //   message: msg,
        //   latitude: 0,
        //   longitude: 0,
        //   type: 'text',
        //   createdAt: DateTime.now(),
        //   updatedAt: DateTime.now(),
        // );

        // await createConversationMutation.mutateAsync({
        //   'msg': msgObject,
        //   'type': conversation.type,
        //   'members': conversation.type == 'private'
        //       ? [currentUser.value.id!, user.id!]
        //       : conversation.members!.map((user) => user.id),
        // });

        // if (createConversationMutation.hasError) {
        //   log('mutation error: ${createConversationMutation.error}');
        //   createConversationMutation.reset();
        // } else if (createConversationMutation.hasData) {
        //   userNameSpace
        //     ..on(
        //       'onConversationCreated',
        //       (data) {
        //         final newConversation = Conversation.fromJson(data);
        //         conversationController.currentConversationId.value =
        //             newConversation.id!;
        //         conversationController.conversations.insert(0, newConversation);
        //       },
        //     );
        //   log('new conversation Id: ${conversationController.currentConversationId.value}');
        //   userNameSpace.emit('join conversation', {
        //     'id': conversationController.currentConversationId.value,
        //   });
        //   controller.messageController.clear();
        //   controller.messageInput.value = '';
        // }
      }
    }

    return Container(
      height: Get.height * 0.08,
      color: context.theme.indicatorColor,
      padding: EdgeInsets.symmetric(horizontal: 15.sp),
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Row(
        children: [
          const InkWell(
            // TODO: Add location dialogue
            // onTap: () => Get.generalDialog(
            //   barrierDismissible: true,
            //   barrierLabel: '',
            //   pageBuilder: (context, animation, secondaryAnimation) =>
            //       FadeTransition(
            //     opacity: animation,
            //     child: ShareLocationDialogue(
            //       type: conversation.type!,
            //       conversationId:
            //           conversationController.currentConversationId.value,
            //       user: user,
            //     ),
            //   ),
            // ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black12,
              ),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(FlutterRemix.map_pin_2_fill),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: TextField(
              controller: controller.messageController,
              cursorColor: AppColors.primaryYellow,
              cursorWidth: 3,
              style: context.theme.textTheme.labelSmall,
              minLines: 6,
              maxLines: null,
              decoration: InputDecoration(
                fillColor: Colors.transparent,
                contentPadding: EdgeInsets.only(top: Get.height * 0.08 / 3),
                hintText: 'Type something',
                hintStyle: context.theme.textTheme.labelSmall,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
              ),
              onChanged: (value) async {
                controller.messageInput.value = value;
              },
            ),
          ),
          const SizedBox(width: 15),
          // createConversationMutation.isLoading &&
          //         !createConversationMutation.hasData
          //     ? LoadingAnimationWidget.staggeredDotsWave(
          //         color: AppColors.primaryYellow,
          //         size: 20.sp,
          //       )
          //     :
          Obx(
            () => Visibility(
              visible: controller.messageInput.value.isNotEmpty ? true : false,
              child: InkWell(
                onTap: () async => controller.sendMessage(userId),
                child: SlideInRight(
                  child: const DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.primaryYellow,
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        FlutterRemix.send_plane_fill,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
