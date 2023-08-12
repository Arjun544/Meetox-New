import 'package:cached_network_image/cached_network_image.dart';
import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/models/user_model.dart';
import 'package:meetox/screens/user_profile_screen/user_profile_screen.dart';

class UserMarker extends StatelessWidget {
  const UserMarker({
    required this.user,
    super.key,
  });
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        InkWell(
          onTap: () => Get.to(() => UserProfileScreen(user: user)),
          child: Container(
            width: 40.sp,
            height: 40.sp,
            decoration: BoxDecoration(
              color: AppColors.customGrey,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                width: 3,
                color: Colors.orange,
              ),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: CachedNetworkImageProvider(
                  user.photo!.isEmpty ? profilePlaceHolder : user.photo!,
                ),
              ),
            ),
          ),
          // : Container(
          //     width: 40.sp,
          //     height: 40.sp,
          //     decoration: BoxDecoration(
          //       color: isQuestionMarker
          //           ? Colors.green
          //           : AppColors.customGrey,
          //       borderRadius: BorderRadius.circular(15),
          //       border: Border.all(
          //         width: 3,
          //         color: color,
          //       ),
          //     ),
          //     child: Icon(
          //       FlutterRemix.question_fill,
          //       color: Colors.white,
          //       size: 35.sp,
          //     ),
          //   ),
        ),
        Positioned(
          bottom: -15,
          child: Icon(
            FlutterRemix.arrow_down_s_fill,
            size: 25.sp,
            color: Colors.orange,
          ),
        ),
      ],
    );
  }
}
