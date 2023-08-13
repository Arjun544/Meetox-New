// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:cached_network_image/cached_network_image.dart';
import 'package:meetox/controllers/my_followers_controller.dart';
import 'package:meetox/controllers/my_profile_controller.dart';
import 'package:meetox/models/user_model.dart';
import 'package:meetox/screens/my_followers_screen/components/follow_remove_button.dart';
import 'package:meetox/widgets/online_indicator.dart';

import '../../../core/imports/core_imports.dart';
import '../../../core/imports/packages_imports.dart';
import 'my_follow_button.dart';

class MyFollowerTile extends StatelessWidget {
  final UserModel user;
  final bool showFollowButton;

  const MyFollowerTile({
    super.key,
    required this.user,
    this.showFollowButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final MyFollowersController controller = Get.find();
    final isRegistered = Get.isRegistered<MyProfileController>();
    return ListTile(
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
      title: Row(
        children: [
          Text(
            user.name == '' ? 'Unknown' : user.name!.capitalize!,
            overflow: TextOverflow.ellipsis,
            style: context.theme.textTheme.labelSmall,
          ),
          MyFollowButton(
            followingId: user.id!,
            onFollow: () {
              if (isRegistered) {
                final MyProfileController myProfileController = Get.find();
                myProfileController.profile.value.followings =
                    (myProfileController.profile.value.followings! + 1);
                myProfileController.profile.refresh();
              }
            },
            onFollowError: () {
              if (isRegistered) {
                final MyProfileController myProfileController = Get.find();
                myProfileController.profile.value.followings =
                    (myProfileController.profile.value.followings! - 1);
                myProfileController.profile.refresh();
              }
            },
            onUnFollow: () {
              if (isRegistered) {
                final MyProfileController myProfileController = Get.find();
                myProfileController.profile.value.followings =
                    (myProfileController.profile.value.followings! - 1);
                myProfileController.profile.refresh();
              }
            },
            onUnFollowError: () {
              if (isRegistered) {
                final MyProfileController myProfileController = Get.find();
                myProfileController.profile.value.followings =
                    (myProfileController.profile.value.followings! + 1);
                myProfileController.profile.refresh();
              }
            },
          ),
        ],
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
      trailing: showFollowButton
          ? FollowRemoveButton(
              user: user,
              onRemove: () {
                controller.followersPagingController.itemList!
                    .removeWhere((element) => element.id == user.id!);
                controller.followersPagingController.notifyListeners();
                final MyProfileController myProfileController = Get.find();
                myProfileController.profile.value.followers =
                    (myProfileController.profile.value.followers! - 1);
                myProfileController.profile.refresh();
              },
              onRemoveError: () {
                controller.followersPagingController.itemList!.insert(
                    controller.followersPagingController.itemList!
                        .indexOf(user),
                    user);
                controller.followersPagingController.notifyListeners();
                final MyProfileController myProfileController = Get.find();
                myProfileController.profile.value.followers =
                    (myProfileController.profile.value.followers! + 1);
                myProfileController.profile.refresh();
              },
            )
          : const SizedBox.shrink(),
    );
  }
}
