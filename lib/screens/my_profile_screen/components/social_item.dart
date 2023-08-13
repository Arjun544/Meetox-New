import 'package:flutter/cupertino.dart';
import 'package:meetox/controllers/my_profile_controller.dart';
import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/helpers/get_social.dart';
import 'package:meetox/helpers/launch_url.dart';
import 'package:meetox/screens/my_profile_screen/components/add_social_sheet.dart';
import 'package:meetox/widgets/custom_sheet.dart';

class SocialItem extends GetView<MyProfileController> {
  final String type;

  const SocialItem({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => InkWell(
        onTap: () => currentUser.value.socials!
                    .map((e) => e.type)
                    .toList()
                    .contains(type) ==
                false
            ? showCustomSheet(
                context: context,
                child: AddSocialSheet(
                  type,
                ),
              )
            : showCupertinoModalPopup(
                context: context,
                builder: (context) => CupertinoActionSheet(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: context.theme.scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            getSocial(type),
                            color: AppColors.customBlack.withOpacity(currentUser
                                        .value.socials!
                                        .map((e) => e.type)
                                        .toList()
                                        .contains(type) ==
                                    true
                                ? 1
                                : 0.5),
                          ),
                        ),
                      ),
                      SizedBox(width: 15.w),
                      Text(
                        type.capitalizeFirst!,
                        style: context.theme.textTheme.labelMedium,
                      ),
                    ],
                  ),
                  cancelButton: CupertinoActionSheetAction(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: context.theme.textTheme.labelMedium,
                    ),
                  ),
                  actions: [
                    CupertinoActionSheetAction(
                      onPressed: () async {
                        appLaunchUrl(currentUser.value.socials!
                            .where((element) => element.type == type)
                            .toList()[0]
                            .url!);
                      },
                      child: Text(
                        'Open Url',
                        style: context.theme.textTheme.labelMedium,
                      ),
                    ),
                    CupertinoActionSheetAction(
                      onPressed: () => showCustomSheet(
                        context: context,
                        child: AddSocialSheet(
                          type,
                          url: currentUser.value.socials!
                              .where((element) => element.type == type)
                              .toList()[0]
                              .url!,
                        ),
                      ),
                      child: Text(
                        'Edit',
                        style: context.theme.textTheme.labelMedium,
                      ),
                    ),
                    Obx(
                      () => controller.removeSocialIsLoading.value
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Get.width * 0.45, vertical: 8.h),
                              child: LoadingAnimationWidget.staggeredDotsWave(
                                color: AppColors.primaryYellow,
                                size: 20.sp,
                              ),
                            )
                          : CupertinoActionSheetAction(
                              isDestructiveAction: true,
                              onPressed: () => controller.handleRemoveSocial(
                                  context,
                                  type: type.toLowerCase()),
                              child: Text(
                                'Remove',
                                style: context.theme.textTheme.labelMedium!
                                    .copyWith(
                                  color: Colors.redAccent,
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: context.theme.indicatorColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              getSocial(type),
              color: AppColors.customBlack.withOpacity(
                currentUser.value.socials!
                            .map((e) => e.type)
                            .toList()
                            .contains(type) ==
                        true
                    ? 1
                    : 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
