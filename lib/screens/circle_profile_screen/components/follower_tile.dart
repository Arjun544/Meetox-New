import 'package:cached_network_image/cached_network_image.dart';
import 'package:meetox/controllers/circle_profile_controller.dart';
import 'package:meetox/models/user_model.dart';
import 'package:meetox/screens/user_profile_screen/user_profile_screen.dart';
import 'package:meetox/widgets/join_button.dart';
import 'package:meetox/widgets/online_indicator.dart';

import '../../../core/imports/core_imports.dart';
import '../../../core/imports/packages_imports.dart';

class FollowerTile extends GetView<CircleProfileController> {
  final UserModel user;

  const FollowerTile({
    super.key,
    required this.user,
  });
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => Get.to(
        () => UserProfileScreen(
          user: user,
        ),
      ),
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
                  user.photo!.isEmpty ? profilePlaceHolder : user.photo!,
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
      trailing: user.id != currentUser.value.id
          ? JoinButton(
              id: controller.circle.value.id!,
              isPrivate: controller.circle.value.isPrivate!,
              limit: controller.circle.value.limit!,
              isAdmin: true,
            )
          : const SizedBox.shrink(),
    );
  }
}
