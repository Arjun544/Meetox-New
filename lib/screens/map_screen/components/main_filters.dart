import 'dart:async';

import 'package:meetox/controllers/map_controller.dart';
import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';

class MainFilters extends GetView<MapScreenController> {
  const MainFilters({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 15.sp),
      child: Column(
        children: [
          // InkWell(
          //   onTap: () => showCustomSheet(
          //     context: context,
          //     child: FiltersSheet(
          //       usersResult,
          //       circlesResult,
          //       questionsResult,
          //     ),
          //   ),
          //   child: Container(
          //     height: 50.sp,
          //     width: 55.sp,
          //     alignment: Alignment.center,
          //     decoration: BoxDecoration(
          //       color: context.theme.dividerColor,
          //       borderRadius: BorderRadius.circular(15),
          //     ),
          //     child: Stack(
          //       clipBehavior: Clip.none,
          //       children: [
          //         const Icon(IconsaxBold.setting_4),
          //         Obx(
          //           () => controller.hasAppliedFilters.value
          //               ? Positioned(
          //                   right: -5,
          //                   top: -5,
          //                   child: Container(
          //                     height: 10.sp,
          //                     width: 10.sp,
          //                     decoration: const BoxDecoration(
          //                       shape: BoxShape.circle,
          //                       color: Colors.green,
          //                     ),
          //                   ),
          //                 )
          //               : const SizedBox.shrink(),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          SizedBox(height: 20.h),
          Obx(
            () => AnimatedContainer(
              height:
                  controller.isFiltersVisible.value ? Get.height * 0.3 : 50.sp,
              width: 55.sp,
              duration: const Duration(milliseconds: 300),
              padding: EdgeInsets.symmetric(vertical: 15.sp),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: context.theme.dividerColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: controller.isFiltersVisible.value
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            if (controller.currentMainFilter.value != 'All') {
                              controller.isCurrentFilterMarkVisible(true);
                              Timer.periodic(const Duration(seconds: 2),
                                  (timer) {
                                controller.isCurrentFilterMarkVisible(false);
                                timer.cancel();
                              });
                            }
                            controller.currentMainFilter.value = 'All';
                          },
                          child: SizedBox(
                            width: Get.width,
                            child: Obx(
                              () => Icon(
                                IconsaxBold.element_4,
                                size: 22.sp,
                                color:
                                    controller.currentMainFilter.value == 'All'
                                        ? AppColors.primaryYellow
                                        : context.theme.iconTheme.color,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (controller.currentMainFilter.value !=
                                'Circles') {
                              controller.isCurrentFilterMarkVisible(true);
                              Timer.periodic(const Duration(seconds: 2),
                                  (timer) {
                                controller.isCurrentFilterMarkVisible(false);
                                timer.cancel();
                              });
                            }
                            controller.currentMainFilter.value = 'Circles';
                          },
                          child: SizedBox(
                            width: Get.width,
                            child: Obx(
                              () => Icon(
                                FlutterRemix.bubble_chart_fill,
                                size: 22.sp,
                                color: controller.currentMainFilter.value ==
                                        'Circles'
                                    ? Colors.lightBlue
                                    : context.theme.iconTheme.color,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (controller.currentMainFilter.value !=
                                'Questions') {
                              controller.isCurrentFilterMarkVisible(true);
                              Timer.periodic(const Duration(seconds: 2),
                                  (timer) {
                                controller.isCurrentFilterMarkVisible(false);
                                timer.cancel();
                              });
                            }
                            controller.currentMainFilter.value = 'Questions';
                          },
                          child: SizedBox(
                            width: Get.width,
                            child: Obx(
                              () => Icon(
                                FlutterRemix.question_fill,
                                size: 22.sp,
                                color: controller.currentMainFilter.value ==
                                        'Questions'
                                    ? Colors.green
                                    : context.theme.iconTheme.color,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (controller.currentMainFilter.value !=
                                'Followers') {
                              controller.isCurrentFilterMarkVisible(true);
                              Timer.periodic(const Duration(seconds: 2),
                                  (timer) {
                                controller.isCurrentFilterMarkVisible(false);
                                timer.cancel();
                              });
                            }
                            controller.currentMainFilter.value = 'Followers';
                          },
                          child: SizedBox(
                            width: Get.width,
                            child: Obx(
                              () => Icon(
                                IconsaxBold.profile_2user,
                                size: 22.sp,
                                color: controller.currentMainFilter.value ==
                                        'Followers'
                                    ? AppColors.primaryYellow
                                    : context.theme.iconTheme.color,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (controller.currentMainFilter.value != 'Users') {
                              controller.isCurrentFilterMarkVisible(true);
                              Timer.periodic(const Duration(seconds: 2),
                                  (timer) {
                                controller.isCurrentFilterMarkVisible(false);
                                timer.cancel();
                              });
                            }
                            controller.currentMainFilter.value = 'Users';
                          },
                          child: SizedBox(
                            width: Get.width,
                            child: Obx(
                              () => Icon(
                                IconsaxBold.people,
                                size: 20.sp,
                                color: controller.currentMainFilter.value ==
                                        'Users'
                                    ? Colors.orange
                                    : context.theme.iconTheme.color,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : InkWell(
                      onTap: () => controller.currentMainFilter.value = 'All',
                      child: Obx(
                        () => Icon(
                          IconsaxBold.element_4,
                          size: 25.sp,
                          color: controller.currentMainFilter.value == 'All'
                              ? AppColors.primaryYellow
                              : context.theme.iconTheme.color,
                        ),
                      ),
                    ),
            ),
          ),
          Obx(
            () => InkWell(
              onTap: () => controller.isFiltersVisible.value =
                  !controller.isFiltersVisible.value,
              child: Icon(
                controller.isFiltersVisible.value
                    ? IconsaxBold.arrow_up_1
                    : IconsaxBold.arrow_down,
                color: context.theme.dividerColor,
                size: 30.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
