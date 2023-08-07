import 'package:cached_network_image/cached_network_image.dart';
import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/models/profile_model.dart';
import 'package:meetox/screens/followers_screen/followers_screen.dart';
import 'package:meetox/screens/profile_screen/components/date_picker_sheet.dart';
import 'package:meetox/widgets/custom_sheet.dart';
import 'package:meetox/widgets/premium_button.dart';

import 'social_item.dart';

class MyDetails extends HookWidget {
  final Query<ProfileModel, dynamic> userProfile;
  const MyDetails(this.userProfile, {super.key});

  @override
  Widget build(BuildContext context) {
    final selectedDOB = useState(userProfile.data?.dob ?? DateTime.now());
    return SliverAppBar(
      elevation: 0.1,
      expandedHeight: Get.height * 0.45,
      collapsedHeight: 130,
      pinned: true,
      title: Obx(
        () => Text(
          currentUser.value.name!.capitalizeFirst!,
          style: context.theme.textTheme.labelMedium,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: Size(Get.width, 0),
        child: const PremiumButton(),
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
                    () => Stack(
                      alignment: Alignment.bottomRight,
                      clipBehavior: Clip.none,
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
                                currentUser.value.photo!,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: -4,
                          bottom: -4,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: AppColors.customBlack,
                              border: Border.all(
                                width: 3,
                                color: context.theme.scaffoldBackgroundColor,
                              ),
                            ),
                            child: const Icon(
                              FlutterRemix.add_fill,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.w),
                  GestureDetector(
                    onTap: () {
                      if (userProfile.data!.followings != 0) {
                        Get.to(() => FollowersScreen(currentUser.value, true));
                      }
                    },
                    child: Column(
                      children: [
                        Text(
                          userProfile.data?.feeds.toString() ?? '',
                          style: context.theme.textTheme.labelMedium,
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
                      if (userProfile.data!.followers != 0) {
                        Get.to(() => FollowersScreen(currentUser.value, false));
                      }
                    },
                    child: Column(
                      children: [
                        Text(
                          userProfile.data?.followers.toString() ?? '',
                          style: context.theme.textTheme.labelMedium,
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
                      if (userProfile.data!.followings != 0) {
                        Get.to(() => FollowersScreen(currentUser.value, true));
                      }
                    },
                    child: Column(
                      children: [
                        Text(
                          userProfile.data?.followings.toString() ?? '',
                          style: context.theme.textTheme.labelMedium,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SocialItem(
                    type: 'facebook',
                  ),
                  SizedBox(width: 20.w),
                  const SocialItem(
                    type: 'instagram',
                  ),
                  SizedBox(width: 20.w),
                  const SocialItem(
                    type: 'whatsapp',
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        'Your birthday on ',
                        style: context.theme.textTheme.labelSmall!.copyWith(
                          color: context.theme.textTheme.labelSmall!.color!
                              .withOpacity(0.5),
                        ),
                      ),
                      Text(
                        formatDate(
                          userProfile.data?.dob ?? DateTime.now(),
                          [d, ', ', M, ' ', yyyy],
                        ),
                        style: context.theme.textTheme.labelSmall,
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      selectedDOB.value = userProfile.data!.dob!;
                      showCustomSheet(
                        context: context,
                        child: DatePickerSheet(
                          selectedDate: selectedDOB,
                          userProfile: userProfile,
                        ),
                      );
                    },
                    child: Text(
                      'Change',
                      style: context.theme.textTheme.labelSmall!.copyWith(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
