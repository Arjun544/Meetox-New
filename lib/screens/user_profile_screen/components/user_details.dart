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
  final UserModel user;

  const UserDetails(this.user, {super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      elevation: 0.1,
      expandedHeight: Get.height * 0.37,
      collapsedHeight: 100,
      pinned: true,
      title: Text(
        user.name!.capitalizeFirst!,
        style: context.theme.textTheme.labelMedium,
      ),
      actions: [
        NavigateButton(
          title: user.name!.capitalizeFirst!,
          address: user.address!,
          latitude: user.location!.latitude!,
          longitude: user.location!.longitude!,
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
                      color: context.theme.indicatorColor,
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(
                          user.photo!,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (controller.followerCount.value != 0) {
                        Get.to(() => FollowersScreen(user, false));
                      }
                    },
                    child: Column(
                      children: [
                        Obx(
                          () => Text(
                            controller.followerCount.value.toString(),
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
                      if (controller.followingCount.value != 0) {
                        Get.to(() => FollowersScreen(user, true));
                      }
                    },
                    child: Column(
                      children: [
                        Obx(
                          () => Text(
                            controller.followingCount.toString(),
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
                ],
              ),
              SizedBox(height: 30.h),
              Obx(
                () => IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FollowButton(
                        id: user.id!,
                        followers: controller.followerCount,
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
                      controller.isSocialsLoading.value
                          ? const SocialsLoaders()
                          : controller.socials.value.isEmpty
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
                                      children: controller.socials.value
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
