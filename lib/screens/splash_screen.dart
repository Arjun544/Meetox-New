import 'package:fl_query_hooks/fl_query_hooks.dart';
import '../controllers/global_controller.dart';
import '../controllers/splash_controller.dart';
import '../core/imports/core_imports.dart';
import '../core/imports/packages_imports.dart';
import 'add_profile_screen/add_profile_screen.dart';
import 'auth_screens/auth_screen.dart';
import 'root_screen.dart';
import '../services/user_services.dart';

class SplashScreen extends HookWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get
      ..put(SplashController())
      ..put(GlobalController(), permanent: true);

    useQuery(
      CacheKeys.currentUser,
      () async {
        return await UserServices.getCurrentUser();
      },
      onData: (data) {
        if (data.name == null) {
          Get.offAll(() => const AddProfileScreen());
        } else {
          currentUser(data);
          Get.offAll(() => const RootScreen());
        }
      },
      onError: (value) => Get.offAll(() => const AuthScreen()),
    );

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryYellow,
              Colors.yellow[200]!,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox.shrink(),
            Column(
              children: [
                Swing(
                  infinite: true,
                  child: Hero(
                    tag: 'Logo',
                    child: SvgPicture.asset(
                      AssetsManager.appLogo,
                      height: 50.h,
                      colorFilter: const ColorFilter.mode(
                        AppColors.customBlack,
                        BlendMode.srcIn,
                      ),
                      theme: const SvgTheme(
                        currentColor: AppColors.customBlack,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 14.h),
                Text(
                  'Meetox',
                  style: context.theme.textTheme.titleLarge!.copyWith(
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold,
                    color: AppColors.customBlack,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 30.h),
              child: LoadingAnimationWidget.threeArchedCircle(
                color: AppColors.customBlack,
                size: 20.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
