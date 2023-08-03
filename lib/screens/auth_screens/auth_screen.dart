import 'package:fl_query_hooks/fl_query_hooks.dart';
import '../../controllers/auth_controller.dart';
import '../../core/imports/core_imports.dart';
import '../../core/imports/packages_imports.dart';
import '../../helpers/show_toast.dart';
import '../../models/user_model.dart';
import '../../services/auth_services.dart';
import '../../services/user_services.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/loaders/botton_loader.dart';

import '../add_profile_screen/add_profile_screen.dart';
import '../root_screen.dart';

class AuthScreen extends HookWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.put(AuthController());

    final loginWithGoogleMutation = useMutation(
      'loginWithGoogle',
      (Map<String, dynamic> variables) async =>
          await AuthServices.signInWithGoogle(
        variables['isLoading'],
      ),
      onData: (data, recoveryData) async {
        final UserModel user = await UserServices.getCurrentUser();
        currentUser(user);
        if (currentUser.value.name == null) {
          Get.offAll(() => const AddProfileScreen());
        } else {
          Get.offAll(() => const RootScreen());
        }
        authController.isLoading(false);
      },
      onError: (error, recoveryData) {
        authController.isLoading(false);
        logError(error.toString());
        showToast('Sign in failed');
      },
    );

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: context.theme.appBarTheme.backgroundColor,
        elevation: 0,
        systemOverlayStyle: context.theme.appBarTheme.systemOverlayStyle,
        iconTheme: context.theme.appBarTheme.iconTheme,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Column(
                children: [
                  Hero(
                    tag: 'Logo',
                    child: SvgPicture.asset(
                      AssetsManager.appLogo,
                      height: 70.h,
                      colorFilter: const ColorFilter.mode(
                        AppColors.primaryYellow,
                        BlendMode.darken,
                      ),
                    ),
                  ),
                  SizedBox(height: 50.sp),
                  Text(
                    'Get ready to meet',
                    style: context.theme.textTheme.titleMedium,
                  ),
                  Text(
                    'Your next best match',
                    style: context.theme.textTheme.titleMedium!
                        .copyWith(color: AppColors.primaryYellow),
                  ),
                ],
              ),
              SizedBox(height: 100.sp),
              Column(
                children: [
                  FadeInUp(
                    child: ElasticIn(
                      duration: const Duration(seconds: 2),
                      child: SlideInUp(
                        delay: const Duration(seconds: 1),
                        duration: const Duration(milliseconds: 400),
                        from: 280,
                        child: CustomButton(
                          width: Get.width * 0.9,
                          text: 'Continue with Passwordless',
                          color: context.theme.cardColor,
                          hasIcon: true,
                          icon: IconTheme(
                            data: context.theme.iconTheme
                                .copyWith(color: AppColors.customBlack),
                            child: const Icon(
                              FlutterRemix.magic_fill,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {},
                          // onPressed: () async =>
                          //     Get.to(() => const PasswordlessAutScreen()),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.sp,
                  ),
                  FadeInUp(
                    child: ElasticIn(
                      duration: const Duration(seconds: 2),
                      child: SlideInUp(
                        delay: const Duration(seconds: 1),
                        from: 300,
                        duration: const Duration(milliseconds: 400),
                        child: CustomButton(
                          width: Get.width * 0.9,
                          text: 'Continue with WhatsApp',
                          color: Colors.teal,
                          hasIcon: true,
                          icon: IconTheme(
                            data: context.theme.iconTheme
                                .copyWith(color: AppColors.customBlack),
                            child: const Icon(
                              FlutterRemix.whatsapp_fill,
                              color: AppColors.customBlack,
                            ),
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15.sp,
              ),
              FadeInUp(
                child: ElasticIn(
                  duration: const Duration(seconds: 2),
                  child: SlideInUp(
                    delay: const Duration(seconds: 1),
                    duration: const Duration(milliseconds: 400),
                    from: 330,
                    child: Obx(
                      () => authController.isLoading.value
                          ? ButtonLoader(
                              width: Get.width * 0.9,
                              color: Colors.redAccent[100]!,
                              loaderColor: Colors.white,
                            )
                          : CustomButton(
                              width: Get.width * 0.9,
                              text: 'Continue with Google',
                              hasIcon: true,
                              color: Colors.redAccent[100]!,
                              icon: IconTheme(
                                data: context.theme.iconTheme,
                                child: const Icon(
                                  FlutterRemix.google_fill,
                                ),
                              ),
                              onPressed: () async =>
                                  await loginWithGoogleMutation.mutate({
                                'isLoading': authController.isLoading,
                              }),
                            ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15.sp,
              ),
              FadeInUp(
                child: ElasticIn(
                  duration: const Duration(seconds: 2),
                  child: SlideInUp(
                    delay: const Duration(seconds: 1),
                    duration: const Duration(milliseconds: 400),
                    from: 350,
                    child: CustomButton(
                      width: Get.width * 0.9,
                      icon: IconTheme(
                        data: context.theme.iconTheme,
                        child: const Icon(
                          FlutterRemix.facebook_fill,
                        ),
                      ),
                      hasIcon: true,
                      color: Colors.blueAccent[100]!,
                      text: 'Continue with Facebook',
                      onPressed: () {},
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50.sp),
              FadeInUp(
                child: ElasticIn(
                  duration: const Duration(seconds: 2),
                  child: SlideInUp(
                    delay: const Duration(seconds: 1),
                    duration: const Duration(milliseconds: 400),
                    from: 350,
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'By continuing, you accept our\n',
                        style: context.theme.textTheme.labelSmall!
                            .copyWith(color: Colors.grey),
                        children: [
                          TextSpan(
                            text: 'privacy policy',
                            style: context.theme.textTheme.labelSmall!.copyWith(
                              color: AppColors.primaryYellow,
                            ),
                          ),
                          TextSpan(
                            text: ' and ',
                            style: context.theme.textTheme.labelSmall!
                                .copyWith(color: Colors.grey),
                          ),
                          TextSpan(
                            text: 'terms of services',
                            style: context.theme.textTheme.labelSmall!
                                .copyWith(color: AppColors.primaryYellow),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
