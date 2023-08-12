import 'package:cached_network_image/cached_network_image.dart';
import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/models/user_model.dart';
import 'package:meetox/screens/user_profile_screen/user_profile_screen.dart';

class FollowerMarker extends StatelessWidget {
  const FollowerMarker({
    required this.follower,
    required this.tappedFollower,
    super.key,
  });
  final UserModel follower;
  final Rx<UserModel> tappedFollower;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        InkWell(
          onTap: () {
            Get.to(() => UserProfileScreen(user: follower));
          },
          child: Container(
            width: 40.sp,
            height: 40.sp,
            decoration: BoxDecoration(
              color: AppColors.customGrey,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                width: 3,
                color: AppColors.primaryYellow,
              ),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: CachedNetworkImageProvider(
                  follower.photo!.isEmpty
                      ? profilePlaceHolder
                      : follower.photo!,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -15,
          child: Icon(
            FlutterRemix.arrow_down_s_fill,
            size: 25.sp,
            color: AppColors.primaryYellow,
          ),
        ),
      ],
    );
  }
}
