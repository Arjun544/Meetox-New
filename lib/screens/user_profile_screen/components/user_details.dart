// ignore_for_file: invalid_use_of_protected_member

import 'package:cached_network_image/cached_network_image.dart';
import 'package:meetox/controllers/user_profile_controller.dart';
import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/helpers/get_social.dart';
import 'package:meetox/helpers/launch_url.dart';
import 'package:meetox/models/user_model.dart';
import 'package:meetox/screens/followers_screen/followers_screen.dart';
import 'package:meetox/widgets/custom_tabbar.dart';
import 'package:meetox/widgets/follow_button.dart';
import 'package:meetox/widgets/loaders/socials_loaders.dart';
import 'package:meetox/widgets/navigate_button.dart';

class UserDetails extends GetView<UserProfileController> {
  const UserDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      elevation: 0.1,
      expandedHeight: Get.height * 0.37,
      collapsedHeight: 100,
      pinned: true,
      title: Obx(
        () => Text(
          controller.profile.value.name?.capitalizeFirst ?? '',
          style: context.theme.textTheme.labelMedium,
        ),
      ),
      actions: [
        Obx(
          () => controller.profile.value.id == null
              ? const SizedBox.shrink()
              : NavigateButton(
                  title: controller.profile.value.name!.capitalizeFirst!,
                  address: controller.profile.value.address!,
                  latitude: controller.user.value.location!.latitude!,
                  longitude: controller.user.value.location!.longitude!,
                ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: Size(Get.width, 0),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: CustomTabbar(
            controller: controller.tabController,
            tabs: const [
              Text('Info'),
              Text('Feeds'),
            ],
            onTap: (int value) {},
          ),
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
                  Container(
                    height: Get.height * 0.09,
                    width: Get.width * 0.18,
                    decoration: BoxDecoration(
                      color: context.theme.primaryColor,
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(
                          controller.user.value.photo!,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.w),
                  GestureDetector(
                    onTap: controller.tabController.index != 1
                        ? () => controller.tabController.animateTo(1)
                        : null,
                    child: Column(
                      children: [
                        Obx(
                          () => Text(
                            controller.profile.value.feeds == null
                                ? '0'
                                : controller.profile.value.feeds.toString(),
                            style: context.theme.textTheme.labelMedium,
                          ),
                        ),
                        Text(
                          'Feeds',
                          style: context.theme.textTheme.labelSmall!
                              .copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (controller.profile.value.followers != 0) {
                        Get.to(() => FollowersScreen(
                              UserModel(
                                id: controller.profile.value.id,
                                name: controller.profile.value.name,
                              ),
                              false,
                            ));
                      }
                    },
                    child: Column(
                      children: [
                        Obx(
                          () => Text(
                            controller.profile.value.followers == null
                                ? '0'
                                : controller.profile.value.followers.toString(),
                            style: context.theme.textTheme.labelMedium,
                          ),
                        ),
                        Text(
                          'Followers',
                          style: context.theme.textTheme.labelSmall!
                              .copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (controller.profile.value.followings != 0) {
                        Get.to(
                          () => FollowersScreen(
                            UserModel(
                              id: controller.profile.value.id,
                              name: controller.profile.value.name,
                            ),
                            true,
                          ),
                        );
                      }
                    },
                    child: Column(
                      children: [
                        Obx(
                          () => Text(
                            controller.profile.value.followings == null
                                ? '0'
                                : controller.profile.value.followings
                                    .toString(),
                            style: context.theme.textTheme.labelMedium,
                          ),
                        ),
                        Text(
                          'Followings',
                          style: context.theme.textTheme.labelSmall!
                              .copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.w),
                ],
              ),
              SizedBox(height: 30.h),
              Obx(
                () => controller.profile.value.id == null
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SocialsLoaders(),
                        ],
                      )
                    : IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FollowButton(
                              followerId: controller.profile.value.id!,
                              followingId: currentUser.value.id!,
                              onFollow: () {
                                controller.profile.value.followers =
                                    controller.profile.value.followers! + 1;
                                controller.profile.refresh();
                              },
                              onFollowError: () {
                                controller.profile.value.followers =
                                    controller.profile.value.followers! - 1;
                                controller.profile.refresh();
                              },
                              onUnFollow: () {
                                controller.profile.value.followers =
                                    controller.profile.value.followers! - 1;

                                controller.profile.refresh();
                              },
                              onUnFollowError: () {
                                controller.profile.value.followers =
                                    controller.profile.value.followers! + 1;
                                controller.profile.refresh();
                              },
                            ),
                            VerticalDivider(
                              color: context.theme.indicatorColor,
                              width: 20.w,
                              thickness: 2,
                              indent: 5.h,
                              endIndent: 5.h,
                            ),
                            Container(
                              height: 30.h,
                              width: 40.w,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 0,
                                // horizontal: checkHasConversation.result.isLoading
                                //     ? 25.w
                                //     : 0
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
                            controller.profile.value.socials!.isEmpty
                                ? const SizedBox.shrink()
                                : Row(
                                    children: [
                                      VerticalDivider(
                                        color: context.theme.indicatorColor,
                                        width: 20.w,
                                        thickness: 2,
                                        indent: 5.h,
                                        endIndent: 5.h,
                                      ),
                                      Row(
                                        children: controller
                                            .profile.value.socials!
                                            .map<Widget>(
                                              (social) => Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 12.0),
                                                child: InkWell(
                                                  onTap: () =>
                                                      appLaunchUrl(social.url!),
                                                  child: DecoratedBox(
                                                    decoration: BoxDecoration(
                                                      color: context
                                                          .theme.indicatorColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Icon(
                                                        getSocial(social.type!),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ],
                                  ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
