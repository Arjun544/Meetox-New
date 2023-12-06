import 'package:meetox/controllers/add_feed_controller.dart';
import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/screens/add_feed_screen/components/images_list.dart';
import 'package:meetox/widgets/close_button.dart';
import 'package:meetox/widgets/custom_area_field.dart';
import 'package:meetox/widgets/custom_button.dart';
import 'package:meetox/widgets/custom_sheet.dart';
import 'package:meetox/widgets/loaders/botton_loader.dart';
import 'package:meetox/widgets/mini_map.dart';
import 'package:meetox/widgets/unfocuser.dart';

import 'components/select_image_sheet.dart';

class AddFeedScreen extends GetView<AddFeedController> {
  const AddFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AddFeedController());
    return UnFocuser(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            CustomCloseButton(
              onTap: () {
                // Set data back to original
                controller.selectedImages.value = const FilePickerResult([]);
                Get.back();
              },
            ),
            SizedBox(width: 15.w),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 15.sp,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SlideInLeft(
                  delay: const Duration(milliseconds: 500),
                  from: 300,
                  child: Text(
                    'Post a feed to reach the people around you',
                    style: context.theme.textTheme.titleLarge,
                  ),
                ),
                SizedBox(height: 30.sp),
                Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomAreaField(
                        hintText: 'Content',
                        text: ''.obs,
                        controller: controller.contentController,
                        focusNode: FocusNode(),
                        hasFocus: true.obs,
                        formats: [
                          LengthLimitingTextInputFormatter(1000),
                          FilteringTextInputFormatter.allow(
                            RegExp('[a-z A-Z á-ú Á-Ú 0-9 @. \n]'),
                          ),
                        ],
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Content is required';
                          }
                          if (val.length < 2) {
                            return 'Enter at least 2 characters';
                          }
                          return null;
                        },
                      ),
                      Obx(
                        () => SizedBox(
                            height: controller.selectedImages.value.files
                                        .isNotEmpty ||
                                    controller
                                        .capturedImages.value.isNotEmpty ||
                                    controller.isPickingFiles.value
                                ? 0.h
                                : 25.h),
                      ),
                      const ImagesList(),
                      Text(
                        'Location',
                        style: context.theme.textTheme.labelSmall,
                      ),
                      SizedBox(height: 15.sp),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: SizedBox(
                          height: 150.sp,
                          width: Get.width,
                          child: MiniMap(
                            latitude: currentUser.value.location!.latitude!,
                            longitude: currentUser.value.location!.longitude!,
                            image: currentUser.value.photo!.obs,
                            color: AppColors.primaryYellow,
                          ),
                        ),
                      ),
                      SizedBox(height: 80.sp),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: globalHorizentalPadding.right,
            vertical: 20.h,
          ),
          child: Obx(
            () => controller.isLoading.value
                ? ButtonLoader(
                    width: Get.width * 0.4,
                    color: AppColors.customBlack,
                    loaderColor: Colors.white,
                  )
                : Row(
                    children: [
                      GestureDetector(
                        onTap: () => showCustomSheet(
                          context: context,
                          child: const SelectImageSheet(),
                        ),
                        child: Container(
                          padding: EdgeInsets.all(12.sp),
                          decoration: BoxDecoration(
                            color: context.theme.cardColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Icon(
                            FlutterRemix.image_add_fill,
                            color: Colors.white,
                            size: 30.sp,
                          ),
                        ),
                      ),
                      SizedBox(width: 20.w),
                      Expanded(
                        child: CustomButton(
                          width: Get.width,
                          text: 'Post',
                          onPressed: () {
                            if (controller.formKey.currentState!.validate()) {
                              controller.handlePostFeed(context);
                            }
                          },
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
