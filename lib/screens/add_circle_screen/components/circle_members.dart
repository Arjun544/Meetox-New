// ignore_for_file: invalid_use_of_protected_member

import 'package:cached_network_image/cached_network_image.dart';
import 'package:meetox/controllers/add_circle_controller.dart';
import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/models/user_model.dart';
import 'package:meetox/screens/followers_screen/components/follower_tile.dart';
import 'package:meetox/widgets/custom_error_widget.dart';
import 'package:meetox/widgets/custom_field.dart';
import 'package:meetox/widgets/loaders/followers_loader.dart';
import 'package:meetox/widgets/user_initials.dart';

class CircleMembers extends GetView<AddCircleController> {
  const CircleMembers({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.sp),
      child: RefreshIndicator(
        backgroundColor: context.theme.scaffoldBackgroundColor,
        color: AppColors.primaryYellow,
        onRefresh: () async => controller.followersPagingController.refresh(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.sp),
            SlideInLeft(
              delay: const Duration(milliseconds: 500),
              from: 300,
              child: Row(
                children: [
                  Text(
                    'Add members',
                    style: context.theme.textTheme.titleLarge,
                  ),
                  Obx(
                    () => controller.selectedMembers.isNotEmpty
                        ? Text(
                            ' ${controller.selectedMembers.value.length} / ${controller.limit.value.toInt()} ',
                            style: context.theme.textTheme.labelSmall,
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.sp),
            Obx(
              () => controller.selectedMembers.value.isEmpty
                  ? Center(
                      child: Text(
                        'No members selected',
                        style: context.theme.textTheme.labelSmall,
                      ),
                    )
                  : SizedBox(
                      height: Get.height * 0.1,
                      width: Get.width,
                      child: ListView.builder(
                        itemCount: controller.selectedMembers.value.length,
                        padding: EdgeInsets.only(bottom: 10.sp),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                if (controller
                                        .selectedMembers.value[index].photo ==
                                    null)
                                  UserInititals(
                                    name: controller
                                        .selectedMembers.value[index].name!,
                                  )
                                else
                                  CircleAvatar(
                                    maxRadius: 25.sp,
                                    foregroundImage: CachedNetworkImageProvider(
                                      controller
                                          .selectedMembers.value[index].photo!,
                                    ),
                                  ),
                                InkWell(
                                  onTap: () {
                                    controller.selectedMembers.value.remove(
                                      controller.selectedMembers.value[index],
                                    );
                                    controller.selectedMembers.refresh();
                                  },
                                  child: DecoratedBox(
                                    decoration: const BoxDecoration(
                                      color: AppColors.customGrey,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(2),
                                      child: Icon(
                                        FlutterRemix.close_fill,
                                        size: 14.sp,
                                        color: AppColors.customBlack,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
            ),
            SizedBox(height: 10.h),
            SlideInLeft(
              delay: const Duration(milliseconds: 500),
              from: 300,
              child: Text(
                'Followers / Followings',
                style: context.theme.textTheme.labelLarge,
              ),
            ),
            SizedBox(height: 10.h),
            SizedBox(
              height: 40.h,
              width: Get.width,
              child: CustomField(
                hintText: 'Search',
                controller: TextEditingController(),
                focusNode: FocusNode(),
                isPasswordVisible: true.obs,
                hasFocus: false.obs,
                autoFocus: false,
                isSearchField: true,
                keyboardType: TextInputType.text,
                prefixIcon: FlutterRemix.search_2_fill,
                onChanged: (value) => controller.followersSearchQuery(value),
              ),
            ),
            SizedBox(height: 15.h),
            Expanded(
              child: PagedListView.separated(
                padding: EdgeInsets.zero,
                pagingController: controller.followersPagingController,
                separatorBuilder: (context, index) => Divider(
                  thickness: 1,
                  color: context.theme.canvasColor.withOpacity(0.1),
                ),
                builderDelegate: PagedChildBuilderDelegate<UserModel>(
                  animateTransitions: true,
                  transitionDuration: const Duration(milliseconds: 300),
                  firstPageProgressIndicatorBuilder: (_) =>
                      const FollowersLoader(hasCheckBox: false),
                  newPageProgressIndicatorBuilder: (_) =>
                      const FollowersLoader(hasCheckBox: false),
                  firstPageErrorIndicatorBuilder: (_) => Center(
                    child: CustomErrorWidget(
                      image: AssetsManager.angryState,
                      text: 'Failed to fetch followers',
                      onPressed: controller.followersPagingController.refresh,
                    ),
                  ),
                  newPageErrorIndicatorBuilder: (_) => Center(
                    child: CustomErrorWidget(
                      image: AssetsManager.angryState,
                      text: 'Failed to fetch followers',
                      onPressed: controller.followersPagingController.refresh,
                    ),
                  ),
                  noItemsFoundIndicatorBuilder: (_) => CustomErrorWidget(
                    image: AssetsManager.sadState,
                    text: 'No followers found',
                    isWarining: true,
                    onPressed: () {},
                  ),
                  itemBuilder: (context, item, index) => FollowerTile(
                    user: item,
                    showFollowButton: false,
                    onTap: () {
                      if (controller.selectedMembers.contains(item)) {
                        controller.selectedMembers.remove(item);
                      } else {
                        controller.selectedMembers.add(item);
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
