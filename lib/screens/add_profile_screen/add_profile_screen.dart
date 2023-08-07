import '../../controllers/add_profile_controller.dart';
import '../../core/imports/core_imports.dart';
import '../../core/imports/packages_imports.dart';
import '../root_screen.dart';
import '../../services/user_services.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/loaders/botton_loader.dart';

import 'components/step_one.dart';
import 'components/step_three.dart';
import 'components/step_two.dart';

class AddProfileScreen extends HookWidget {
  const AddProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AddProfileController controller = Get.put(AddProfileController());

    useEffect(() {
      controller.nameController.text =
          supabase.auth.currentUser!.userMetadata!['full_name'];
      controller.socialProfile(
          supabase.auth.currentUser!.userMetadata!['avatar_url']);
      return null;
    }, []);

    final uploadImageMutation = useMutation(
      CacheKeys.uploadImage,
      (Map<String, dynamic> variables) async => await UserServices.addProfile(
        isLoading: variables['isLoading'],
        name: variables['name'],
        dob: variables['dob'],
        file: variables['file'],
      ),
      onData: (data, recoveryData) {
        if (data == true) {
          Get.offAll(() => const RootScreen());
        }
      },
      onError: (error, recoveryData) {
        logError(error.toString());
        showToast('Add profile failed');
      },
    );

    return Scaffold(
      body: PageView(
        controller: controller.pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (value) => controller.currentStep.value = value + 1,
        children: const [
          StepOne(),
          StepTwo(),
          StepThree(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SlideInUp(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Obx(
            () => controller.isLoading.value
                ? ButtonLoader(
                    width: Get.width * 0.4,
                    color: AppColors.primaryYellow,
                    loaderColor: Colors.white,
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (controller.currentStep.value > 1)
                        GestureDetector(
                          onTap: () async =>
                              controller.pageController.previousPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          ),
                          child: Container(
                            padding: EdgeInsets.all(12.sp),
                            decoration: BoxDecoration(
                              color: context.isDarkMode
                                  ? Colors.white
                                  : AppColors.customBlack,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              FlutterRemix.arrow_left_s_line,
                              color: context.isDarkMode
                                  ? AppColors.customBlack
                                  : Colors.white,
                              size: 30.sp,
                            ),
                          ),
                        )
                      else
                        const SizedBox.shrink(),
                      SizedBox(width: 50.sp),
                      CustomButton(
                        width: Get.width * 0.4,
                        text: controller.currentStep.value == 3
                            ? 'Submit'
                            : 'Next',
                        color: AppColors.primaryYellow,
                        onPressed: () async {
                          if (controller.currentStep.value == 1) {
                            if (controller.formKey.currentState!.validate()) {
                              FocusScope.of(context).unfocus();
                              await controller.pageController.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );
                            }
                          } else if (controller.currentStep.value == 3) {
                            await controller.handleSubmit(uploadImageMutation);
                          } else {
                            FocusScope.of(context).unfocus();
                            await controller.pageController.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                      ),
                      SizedBox(width: 50.sp),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
