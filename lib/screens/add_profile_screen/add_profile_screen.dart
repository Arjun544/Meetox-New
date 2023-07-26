import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:meetox/controllers/add_profile_controller.dart';
import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/widgets/custom_button.dart';
import 'package:meetox/widgets/loaders/botton_loader.dart';

import 'components/step_one.dart';
import 'components/step_three.dart';
import 'components/step_two.dart';

class AddProfileScreen extends HookWidget {
  const AddProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
   final AddProfileController controller =  Get.put(AddProfileController());

    final addProfileMutation = useMutation(
      CacheKeys.addProfile,
      (variables) async => await supabase.auth.updateUser(
        UserAttributes(
          data: {'hello': 'world'},
        ),
      ),
      onData: (data, recoveryData) {
        logSuccess(data.toString());
      },
      onError: (error, recoveryData) {
        logError(error.toString());
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
          child: addProfileMutation.isMutating
                  ? ButtonLoader(
                      width: Get.width * 0.4,
                      color: AppColors.primaryYellow,
                      loaderColor: Colors.white,
                    )
                  : Obx(
                      () => Row(
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
                                if (controller.formKey.currentState!
                                    .validate()) {
                                  FocusScope.of(context).unfocus();
                                  await controller.pageController.nextPage(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeInOut,
                                  );
                                }
                              } else if (controller.currentStep.value == 3) {
                                await controller.handleSubmit(addProfileMutation);
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
