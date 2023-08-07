import 'package:meetox/controllers/add_circle_controller.dart';
import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/screens/add_circle_screen/components/circle_avatar.dart';
import 'package:meetox/screens/add_circle_screen/components/circle_details.dart';
import 'package:meetox/screens/add_circle_screen/components/circle_privacy.dart';
import 'package:meetox/services/circle_services.dart';
import 'package:meetox/widgets/close_button.dart';
import 'package:meetox/widgets/custom_button.dart';
import 'package:meetox/widgets/loaders/botton_loader.dart';
import 'package:meetox/widgets/unfocuser.dart';

import 'components/circle_members.dart';

class AddCircleScreen extends HookWidget {
  const AddCircleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AddCircleController controller = Get.put(AddCircleController());

    final addCircleMutation = useMutation(
      CacheKeys.addCircle,
      (Map<String, dynamic> variables) async => await CircleServices.addCircle(
        isLoading: controller.isLoading,
        lat: variables['lat'],
        long: variables['long'],
        data: {...variables},
      ),
      onData: (data, recoveryData) {
        if (data.id != null) {
          controller.oData(data);
        }
      },
      onError: (error, recoveryData) {
        logError(error.toString());
        showToast('Create circle failed');
      },
    );

    return UnFocuser(
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(height: 50.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SmoothPageIndicator(
                    controller: controller.pageController, // PageController
                    count: 4,
                    effect: ExpandingDotsEffect(
                      dotHeight: 6.sp,
                      dotWidth: 6.sp,
                      activeDotColor: AppColors.primaryYellow,
                      dotColor: AppColors.customGrey,
                    ), // your preferred effect
                    onDotClicked: (index) {},
                  ),
                  CustomCloseButton(
                    onTap: () {
                      // Set data back to original
                      controller.currentStep.value = 0;
                      controller.nameController.clear();
                      controller.descController.clear();
                      controller.isPrivate.value = false;
                      controller.limit.value = 50.0;
                      controller.selectedAvatar.value = 0;
                      controller.capturedImage.value = XFile('');
                      controller.selectedImage.value =
                          const FilePickerResult([]);
                      Get.back();
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: controller.pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (value) => controller.currentStep.value = value,
                children: const [
                  CircleDetails(),
                  CirclePrivacy(),
                  CircleAvatarDetails(),
                  CircleMembers(),
                ],
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: SlideInUp(
          child: FloatingActionButton.extended(
            backgroundColor: Colors.transparent,
            elevation: 0,
            onPressed: () {},
            label: Obx(
              () => controller.isLoading.value
                  ? ButtonLoader(
                      width: Get.width * 0.4,
                      color: AppColors.primaryYellow,
                      loaderColor: Colors.white,
                    )
                  : Obx(
                      () => Row(
                        children: [
                          if (controller.currentStep.value > 0)
                            GestureDetector(
                              onTap: () async =>
                                  controller.pageController.previousPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              ),
                              child: Container(
                                padding: EdgeInsets.all(12.sp),
                                decoration: BoxDecoration(
                                  color: context.theme.cardColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  FlutterRemix.arrow_left_s_line,
                                  color: Colors.white,
                                  size: 30.sp,
                                ),
                              ),
                            )
                          else
                            const SizedBox.shrink(),
                          SizedBox(width: 50.sp),
                          Obx(
                            () => CustomButton(
                              width: Get.width * 0.4,
                              text: controller.currentStep.value == 3
                                  ? 'Submit'
                                  : 'Next',
                              color: AppColors.primaryYellow,
                              onPressed: () async {
                                if (controller.currentStep.value == 0) {
                                  if (controller.formKey.currentState!
                                      .validate()) {
                                    FocusScope.of(context).unfocus();
                                    await controller.pageController.nextPage(
                                      duration:
                                          const Duration(milliseconds: 500),
                                      curve: Curves.easeInOut,
                                    );
                                  }
                                } else if (controller.currentStep.value == 2) {
                                  await controller.pageController.nextPage(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeInOut,
                                  );
                                } else if (controller.currentStep.value == 3 &&
                                    controller.selectedMembers.length >
                                        controller.limit.value.toInt()) {
                                  showToast(
                                    'Your members limit is ${controller.limit.value.toInt()}',
                                  );
                                } else if (controller.currentStep.value == 3) {
                                  await controller.handleAddCircle(
                                      context, addCircleMutation);
                                } else {
                                  FocusScope.of(context).unfocus();
                                  await controller.pageController.nextPage(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeInOut,
                                  );
                                }
                              },
                            ),
                          ),
                          SizedBox(width: 50.sp),
                        ],
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
