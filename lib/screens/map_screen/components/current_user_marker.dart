import 'package:cached_network_image/cached_network_image.dart';
import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/models/user_model.dart';
import 'package:meetox/screens/my_profile_screen/my_profile_screen.dart';
import 'package:meetox/widgets/user_initials.dart';

class CurrentUserMarker extends StatelessWidget {
  const CurrentUserMarker({super.key, required this.user});
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Pulse(
      infinite: true,
      // ignore: avoid_bool_literals_in_conditional_expressions
      animate: true,
      child: InkWell(
        onTap: () => Get.to(() => const MyProfileScreen()),
        child: Container(
          width: 70.sp,
          height: 70.sp,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.primaryYellow.withOpacity(0.3),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Dance(
            duration: const Duration(milliseconds: 2000),
            infinite: true,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: [
                user.photo == null
                    ? UserInititals(name: user.name!)
                    : user.id == currentUser.value.id
                        ? Obx(
                            () => Container(
                              width: 50.h,
                              height: 50.w,
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                color: AppColors.customGrey,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  width: 4,
                                  color: AppColors.primaryYellow,
                                ),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: CachedNetworkImageProvider(
                                    user.id == currentUser.value.id
                                        ? currentUser.value.photo!
                                        : user.photo!,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(
                            width: 50.w,
                            height: 50.h,
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              color: AppColors.customGrey,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                width: 4,
                                color: AppColors.primaryYellow,
                              ),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: CachedNetworkImageProvider(
                                  user.photo!,
                                ),
                              ),
                            ),
                          ),
                Positioned(
                  bottom: -18,
                  child: Icon(
                    FlutterRemix.arrow_down_s_fill,
                    size: 30.sp,
                    color: AppColors.primaryYellow,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
