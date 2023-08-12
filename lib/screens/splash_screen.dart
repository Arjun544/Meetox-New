import '../controllers/global_controller.dart';
import '../controllers/splash_controller.dart';
import '../core/imports/core_imports.dart';
import '../core/imports/packages_imports.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SplashController());
    Get.put(GlobalController(), permanent: true);

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
