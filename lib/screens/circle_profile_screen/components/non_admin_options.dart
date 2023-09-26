// ignore_for_file: invalid_use_of_protected_member

import 'package:meetox/controllers/circle_profile_controller.dart';
import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/models/conversation_model.dart';
import 'package:meetox/screens/chat_screen/chat_screen.dart';
import 'package:meetox/widgets/join_button.dart';

class NonAdminOptions extends GetView<CircleProfileController> {
  const NonAdminOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          JoinButton(
              isAdmin: controller.profile.value.id == null
                  ? false
                  : controller.profile.value.admin!.id == currentUser.value.id,
              id: controller.circle.value.id!,
              isPrivate: controller.profile.value.isPrivate!,
              hasLimitReached: controller.profile.value.members ==
                  controller.profile.value.limit!,
              onJoin: () {
                controller.profile.value.members =
                    controller.profile.value.members! + 1;
                controller.profile.refresh();
              },
              onJoinError: () {
                controller.profile.value.members =
                    controller.profile.value.members! - 1;
                controller.profile.refresh();
              },
              onLeave: () {
                controller.profile.value.members =
                    controller.profile.value.members! - 1;
                controller.profile.refresh();
              },
              onLeaveError: () {
                controller.profile.value.members =
                    controller.profile.value.members! + 1;
                controller.profile.refresh();
              }),
          VerticalDivider(
            color: context.theme.indicatorColor,
            width: 40.w,
            thickness: 2,
            indent: 5.h,
            endIndent: 5.h,
          ),
          GestureDetector(
            onTap: () => Get.to(
              () => ChatScreen(
                conversation: ConversationModel(
                  type: ConversationType.group,
                ),
                user: controller.profile.value.id!,
              ),
            ),
            child: Container(
              height: 30.h,
              width: 40.w,
              padding: const EdgeInsets.symmetric(
                horizontal: 0,
              ),
              decoration: BoxDecoration(
                color: context.theme.indicatorColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                FlutterRemix.chat_3_fill,
                size: 20.h,
                color: context.theme.iconTheme.color,
              ),
              // child: checkHasConversation.result.isLoading
              //     ? LoadingAnimationWidget.staggeredDotsWave(
              //         color: AppColors.primaryYellow,
              //         size: 20.w,
              //       )
              //     : Icon(
              //         FlutterRemix.chat_3_fill,
              //         size: 22.sp,
              //         color: context.theme.iconTheme.color,
              //       ),
            ),
          ),
        ],
      ),
    );
  }
}
