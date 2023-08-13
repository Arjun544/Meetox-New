// ignore_for_file: invalid_use_of_protected_member

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/models/user_model.dart';
import 'package:meetox/services/follow_services.dart';

class FollowRemoveButton extends StatelessWidget {
  final UserModel user;
  final void Function() onRemove;
  final void Function() onRemoveError;

  const FollowRemoveButton({
    super.key,
    required this.user,
    required this.onRemove,
    required this.onRemoveError,
  });

  @override
  Widget build(BuildContext context) {
    final RxBool isLoading = false.obs;

    void handleRemove() async {
      onRemove();
      Navigator.pop(context);
      await FollowServices.unFollowUser(
        followerId: currentUser.value.id!,
        followingId: user.id!,
        onError: () {
          onRemoveError();
          showToast('Remove failed');
        },
      );
    }

    return Obx(
      () => InkWell(
        onTap: isLoading.value
            ? () {}
            : () => showCupertinoModalPopup(
                  context: context,
                  builder: (context) => CupertinoActionSheet(
                    title: CircleAvatar(
                      radius: 24.h,
                      foregroundColor: AppColors.primaryYellow,
                      backgroundColor: AppColors.primaryYellow,
                      foregroundImage: CachedNetworkImageProvider(user.photo!),
                    ),
                    message: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'Remove ',
                        style: context.theme.textTheme.labelMedium!.copyWith(
                          color: context.theme.textTheme.labelMedium!.color!
                              .withOpacity(0.5),
                        ),
                        children: [
                          TextSpan(
                            text: '${user.name!.capitalizeFirst!}?',
                            style: context.theme.textTheme.labelMedium,
                          ),
                        ],
                      ),
                    ),
                    cancelButton: CupertinoActionSheetAction(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancel',
                        style: context.theme.textTheme.labelMedium,
                      ),
                    ),
                    actions: [
                      Obx(
                        () => isLoading.value
                            ? Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Get.width * 0.44,
                                    vertical: 8.h),
                                child: LoadingAnimationWidget.staggeredDotsWave(
                                  color: AppColors.primaryYellow,
                                  size: 20.sp,
                                ),
                              )
                            : CupertinoActionSheetAction(
                                isDestructiveAction: true,
                                onPressed: () => handleRemove(),
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
            padding: EdgeInsets.symmetric(
              horizontal: 12.sp,
              vertical: 6.sp,
            ),
            child: isLoading.value
                ? LoadingAnimationWidget.staggeredDotsWave(
                    color: context.isDarkMode
                        ? AppColors.customGrey
                        : AppColors.customBlack,
                    size: 20.sp,
                  )
                : Text(
                    'Remove',
                    style: context.theme.textTheme.labelSmall,
                  ),
          ),
        ),
      ),
    );
  }
}
