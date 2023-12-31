// ignore_for_file: invalid_use_of_protected_member

import 'package:cached_network_image/cached_network_image.dart';
import 'package:meetox/controllers/my_profile_controller.dart';
import 'package:meetox/models/user_model.dart';
import 'package:meetox/widgets/follow_button.dart';
import 'package:meetox/widgets/online_indicator.dart';

import '../../../core/imports/core_imports.dart';
import '../../../core/imports/packages_imports.dart';

class FollowerTile extends StatelessWidget {
  final UserModel user;
  final bool showFollowButton;
  final VoidCallback? onTap;

  const FollowerTile(
      {super.key,
      required this.user,
      this.showFollowButton = true,
      this.onTap});
  @override
  Widget build(BuildContext context) {
    final isRegistered = Get.isRegistered<MyProfileController>();
    return ListTile(
      onTap: onTap,
      splashColor: Colors.transparent,
      contentPadding: EdgeInsets.zero,
      leading: Stack(
        children: [
          Container(
            width: 40.sp,
            height: 40.sp,
            decoration: BoxDecoration(
              color: AppColors.primaryYellow,
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: CachedNetworkImageProvider(
                  user.photo! == '' ? profilePlaceHolder : user.photo!,
                ),
              ),
            ),
          ),
          OnlineIndicator(id: user.id!),
        ],
      ),
      title: Text(
        user.name == '' ? 'Unknown' : user.name!.capitalize!,
        overflow: TextOverflow.ellipsis,
        style: context.theme.textTheme.labelSmall,
      ),
      subtitle: Row(
        children: [
          const Icon(
            FlutterRemix.map_pin_2_fill,
            size: 12,
          ),
          const SizedBox(width: 8),
          Text(
            user.address == '' ? 'Unknown' : user.address!,
            style:
                context.theme.textTheme.labelSmall!.copyWith(fontSize: 10.sp),
          ),
        ],
      ),
      trailing: user.id != currentUser.value.id && showFollowButton
          ? FollowButton(
              followerId: user.id!,
              followingId: currentUser.value.id!,
              onFollow: () {
                if (isRegistered) {
                  final MyProfileController controller = Get.find();
                  controller.profile.value.followings =
                      controller.profile.value.followings! + 1;

                  controller.profile.refresh();
                }
              },
              onFollowError: () {
                if (isRegistered) {
                  final MyProfileController controller = Get.find();
                  controller.profile.value.followings =
                      controller.profile.value.followings! - 1;
                  controller.profile.refresh();
                }
              },
              onUnFollow: () {
                if (isRegistered) {
                  final MyProfileController controller = Get.find();
                  controller.profile.value.followings =
                      controller.profile.value.followings! - 1;
                  controller.profile.refresh();
                }
              },
              onUnFollowError: () {
                if (isRegistered) {
                  final MyProfileController controller = Get.find();
                  controller.profile.value.followings =
                      controller.profile.value.followings! + 1;
                  controller.profile.refresh();
                }
              },
            )
          : const SizedBox.shrink(),
    );
  }
}
