import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/models/circle_model.dart';
import 'package:meetox/widgets/custom_button.dart';
import 'package:meetox/widgets/custom_sheet.dart';
import 'package:meetox/widgets/join_button.dart';

import 'add_member_sheet.dart';
import 'edit_circle.dart';

class CircleDetails extends HookWidget {
  final ValueNotifier<CircleModel> circle;
  final ValueNotifier<int> members;

  const CircleDetails(this.circle, this.members, {super.key});

  @override
  Widget build(BuildContext context) {
    final bool isAdmin = circle.value.adminId == currentUser.value.id;

    return SliverAppBar(
      elevation: 0.1,
      expandedHeight: Get.height * 0.3,
      pinned: true,
      title: Text(
        circle.value.name!.capitalizeFirst!,
        style: context.theme.textTheme.labelMedium,
      ),
      actions: isAdmin
          ? [
              IconButton(
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
                    actions: !isAdmin
                        ? null
                        : [
                            // TODO: Add Delete
                            // Mutation(
                            //   options: MutationOptions(
                            //     document: gql(deleteCircle),
                            //     fetchPolicy: FetchPolicy.networkOnly,
                            //     onCompleted:
                            //         (Map<String, dynamic>? resultData) {
                            //       circlesController.onDeleteCompleted(
                            //         resultData,
                            //         context,
                            //       );
                            //       Get.back();
                            //     },
                            //     onError: (error) =>
                            //         showToast('Failed to delete circle'),
                            //   ),
                            //   builder: (runMutation, result) {
                            //     return result!.isLoading
                            //         ? Padding(
                            //             padding: EdgeInsets.symmetric(
                            //                 horizontal: Get.width * 0.42,
                            //                 vertical: 8.h),
                            //             child: LoadingAnimationWidget
                            //                 .staggeredDotsWave(
                            //               color: AppColors.primaryYellow,
                            //               size: 25.sp,
                            //             ),
                            //           )
                            //         : CupertinoActionSheetAction(
                            //             isDestructiveAction: true,
                            //             onPressed: () => runMutation({
                            //               "id": circle.value.id,
                            //             }),
                            //             child: Text(
                            //               'Delete',
                            //               style: context
                            //                   .theme.textTheme.labelMedium!
                            //                   .copyWith(
                            //                 color: Colors.redAccent,
                            //               ),
                            //             ),
                            //           );
                            //   },
                            // ),
                          ],
                  ),
                ),
                icon: const Icon(
                  IconsaxBold.trash,
                  color: Colors.redAccent,
                ),
              ),
            ]
          : null,
      flexibleSpace: FlexibleSpaceBar(
        background: Padding(
          padding: EdgeInsets.only(top: Get.height * 0.15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: Get.height * 0.09,
                    width: Get.width * 0.18,
                    decoration: BoxDecoration(
                      color: context.theme.indicatorColor,
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(
                          circle.value.photo!,
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
                        Text(
                          members.value.toString(),
                          style: context.theme.textTheme.labelMedium,
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
                      Text(
                        circle.value.limit.toString(),
                        style: context.theme.textTheme.labelMedium,
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
                        () => EditCircle(circle),
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
                        child: AddMemberSheet(
                          id: circle.value.id!,
                          members: members,
                          limit: circle.value.limit!,
                          isPrivate: circle.value.isPrivate!,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              if (circle.value.isPrivate == false && !isAdmin) ...[
                SizedBox(height: 30.h),
                JoinButton(
                  id: circle.value.id!,
                  isPrivate: circle.value.isPrivate!,
                  limit: circle.value.limit!,
                  members: members,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
