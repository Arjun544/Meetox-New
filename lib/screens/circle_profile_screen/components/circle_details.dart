import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:meetox/controllers/circle_profile_controller.dart';
import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/widgets/custom_button.dart';
import 'package:meetox/widgets/custom_sheet.dart';
import 'package:meetox/widgets/join_button.dart';

import 'add_member_sheet.dart';
import 'edit_circle.dart';

class CircleDetails extends GetView<CircleProfileController> {
  const CircleDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isAdmin =
        controller.circle.value.adminId == currentUser.value.id;
    final RxBool isLoading = false.obs;

    return SliverAppBar(
      elevation: 0.1,
      expandedHeight: Get.height * 0.3,
      pinned: true,
      title: Obx(
        () => Text(
          controller.circle.value.name!.capitalizeFirst!,
          style: context.theme.textTheme.labelMedium,
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Padding(
          padding: EdgeInsets.only(top: Get.height * 0.15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Obx(
                    () => Container(
                      height: Get.height * 0.09,
                      width: Get.width * 0.18,
                      decoration: BoxDecoration(
                        color: context.theme.indicatorColor,
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(
                            controller.circle.value.photo!,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Get.to(() => MembersScreen(circle.value));
                    },
                    child: Column(
                      children: [
                        Obx(
                          () => Text(
                            controller.members.value.toString(),
                            style: context.theme.textTheme.labelMedium,
                          ),
                        ),
                        Text(
                          'Members',
                          style: context.theme.textTheme.labelSmall!
                              .copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Obx(
                        () => Text(
                          controller.circle.value.limit.toString(),
                          style: context.theme.textTheme.labelMedium,
                        ),
                      ),
                      Text(
                        'Limit',
                        style: context.theme.textTheme.labelSmall!
                            .copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              if (isAdmin) ...[
                SizedBox(height: 30.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomButton(
                      width: Get.width * 0.15,
                      height: 35.h,
                      color: context.theme.indicatorColor,
                      icon: const Icon(
                        IconsaxBold.edit_2,
                      ),
                      onPressed: () => Get.to(
                        () => const EditCircle(),
                      ),
                    ),
                    CustomButton(
                      width: Get.width * 0.15,
                      height: 35.h,
                      color: context.theme.indicatorColor,
                      icon: const Icon(
                        IconsaxBold.user_add,
                      ),
                      onPressed: () => showCustomSheet(
                        context: context,
                        child: const AddMemberSheet(),
                      ),
                    ),
                    CustomButton(
                      width: Get.width * 0.15,
                      height: 35.h,
                      color: context.theme.indicatorColor,
                      icon: const Icon(
                        IconsaxBold.trash,
                        color: Colors.redAccent,
                      ),
                      onPressed: () => showCupertinoModalPopup(
                        context: context,
                        builder: (context) => CupertinoActionSheet(
                          title: Text(
                            'Are you sure?',
                            style: context.theme.textTheme.labelMedium,
                          ),
                          cancelButton: CupertinoActionSheetAction(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'Cancel',
                              style: context.theme.textTheme.labelMedium,
                            ),
                          ),
                          actions: [
                            isLoading.value
                                ? Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: Get.width * 0.42,
                                        vertical: 8.h),
                                    child: LoadingAnimationWidget
                                        .staggeredDotsWave(
                                      color: AppColors.primaryYellow,
                                      size: 25.sp,
                                    ),
                                  )
                                : CupertinoActionSheetAction(
                                    isDestructiveAction: true,
                                    onPressed: () =>
                                        controller.handleDelete(isLoading),
                                    child: Text(
                                      'Delete',
                                      style: context
                                          .theme.textTheme.labelMedium!
                                          .copyWith(
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              if (controller.circle.value.isPrivate == false && !isAdmin) ...[
                SizedBox(height: 30.h),
                JoinButton(
                  isAdmin: isAdmin,
                  id: controller.circle.value.id!,
                  isPrivate: controller.circle.value.isPrivate!,
                  limit: controller.circle.value.limit!,
                  members: controller.members,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
