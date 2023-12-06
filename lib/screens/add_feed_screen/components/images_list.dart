import 'dart:io';

import 'package:meetox/controllers/add_feed_controller.dart';
import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/widgets/close_button.dart';

class ImagesList extends GetView<AddFeedController> {
  const ImagesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isPickingFiles.value
          ? Row(
              children: List.generate(
              3,
              (index) => Shimmer.fromColors(
                baseColor: context.isDarkMode
                    ? Colors.grey.withOpacity(0.2)
                    : AppColors.customGrey,
                highlightColor: context.isDarkMode
                    ? AppColors.customBlack
                    : Colors.grey[300]!,
                direction: ShimmerDirection.ttb,
                child: Container(
                  height: Get.height * 0.2,
                  width: Get.width * 0.2,
                  margin: EdgeInsets.only(right: 12.w, top: 15.h, bottom: 15.h),
                  decoration: BoxDecoration(
                    color: context.theme.indicatorColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ))
          : controller.selectedImages.value.files.isNotEmpty ||
                  controller.capturedImages.value.isNotEmpty
              ? Padding(
                  padding: EdgeInsets.only(bottom: 15.h),
                  child: Column(
                    children: [
                      SizedBox(height: 25.sp),
                      controller.selectedImages.value.files.isNotEmpty
                          ? SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: controller.selectedImages.value.files
                                    .map((image) => Stack(
                                          children: [
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(right: 12.w),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                child: Image.file(
                                                  File(
                                                    image.path!,
                                                  ),
                                                  height: Get.height * 0.2,
                                                  width: Get.width * 0.3,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: 3,
                                              right: 15,
                                              child: Transform.scale(
                                                scale: 0.7,
                                                child: CustomCloseButton(
                                                  onTap: () {
                                                    controller.selectedImages
                                                        .value.files
                                                        .remove(image);
                                                    controller.selectedImages
                                                        // ignore: invalid_use_of_protected_member
                                                        .refresh();
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ))
                                    .toList(),
                              ),
                            )
                          : SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: controller.capturedImages.value
                                    .map((image) => Stack(
                                          children: [
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(right: 12.w),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                child: Image.file(
                                                  File(
                                                    image.path,
                                                  ),
                                                  height: Get.height * 0.2,
                                                  width: Get.width * 0.3,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: 3,
                                              right: 15,
                                              child: Transform.scale(
                                                scale: 0.7,
                                                child: CustomCloseButton(
                                                  onTap: () {
                                                    controller
                                                        .capturedImages.value
                                                        .remove(image);
                                                    controller.capturedImages
                                                        // ignore: invalid_use_of_protected_member
                                                        .refresh();
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ))
                                    .toList(),
                              ),
                            )
                    ],
                  ),
                )
              : const SizedBox.shrink(),
    );
  }
}
