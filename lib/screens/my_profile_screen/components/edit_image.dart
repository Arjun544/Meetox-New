import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:meetox/controllers/my_profile_controller.dart';

import '../../../core/imports/core_imports.dart';
import '../../../core/imports/packages_imports.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_sheet.dart';
import '../../../widgets/sheets/avatars_sheet.dart';

class EditProfile extends GetView<MyProfileController> {
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Avatar',
          style: context.theme.textTheme.labelMedium,
        ),
        elevation: 0,
        centerTitle: true,
        leading: InkWell(
          onTap: Get.back,
          child: Icon(FlutterRemix.arrow_left_s_line, size: 25.sp),
        ),
        iconTheme: context.theme.appBarTheme.iconTheme,
        actions: [
          Obx(
            () => controller.isLoading.value
                ? Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: LoadingAnimationWidget.staggeredDotsWave(
                      color: AppColors.primaryYellow,
                      size: 20.sp,
                    ),
                  )
                : TextButton(
                    onPressed: controller.socialProfile.value ==
                            currentUser.value.photo
                        ? null
                        : () => controller.handleChangeImage(),
                    child: Text(
                      'Save',
                      style: context.theme.textTheme.labelSmall!.copyWith(
                        color: controller.socialProfile.value ==
                                currentUser.value.photo
                            ? Colors.blueGrey
                            : Colors.blue,
                      ),
                    ),
                  ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: globalHorizentalPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15.h),
            SlideInLeft(
              child: Text(
                'Your Avatar',
                style: context.theme.textTheme.titleLarge,
              ),
            ),
            SizedBox(height: 15.sp),
            SlideInLeft(
              delay: const Duration(milliseconds: 500),
              from: 300,
              child: Text(
                'Choose your avatar to look diffferent and awesome',
                style: context.theme.textTheme.labelSmall,
              ),
            ),
            SizedBox(
              height: 50.sp,
            ),
            Center(
              child: Obx(
                () => CircleAvatar(
                  maxRadius: 60.sp,
                  backgroundColor: AppColors.primaryYellow,
                  backgroundImage: controller.socialProfile.value.isNotEmpty
                      ? CachedNetworkImageProvider(
                          controller.socialProfile.value)
                      : controller.selectedImage.value.files.isEmpty &&
                              controller.capturedImage.value.path.isEmpty
                          ? AssetImage(
                              controller.globalController
                                  .userAvatars[controller.selectedAvatar.value],
                            )
                          : controller.selectedImage.value.files.isEmpty
                              ? Image.file(
                                  File(controller.capturedImage.value.path),
                                ).image
                              : Image.file(
                                  File(
                                    controller
                                        .selectedImage.value.files[0].path!,
                                  ),
                                ).image,
                ),
              ),
            ),
            Obx(
              () => SizedBox(
                height: controller.socialProfile.value.isEmpty ? 30.sp : 50.sp,
              ),
            ),
            Column(
              children: [
                Obx(
                  () => controller.socialProfile.value.isEmpty
                      ? CustomButton(
                          width: Get.width * 0.9,
                          text: 'Set social profile',
                          hasIcon: true,
                          color: context.theme.indicatorColor,
                          icon: IconTheme(
                            data: context.theme.iconTheme,
                            child: const Icon(
                              FlutterRemix.user_4_fill,
                            ),
                          ),
                          onPressed: () =>
                              controller.socialProfile(currentUser.value.photo),
                        )
                      : const SizedBox.shrink(),
                ),
                SizedBox(height: 20.sp),
                CustomButton(
                  width: Get.width * 0.9,
                  text: 'Choose from our avatars',
                  hasIcon: true,
                  color: context.theme.indicatorColor,
                  icon: IconTheme(
                    data: context.theme.iconTheme,
                    child: const Icon(
                      FlutterRemix.user_4_fill,
                    ),
                  ),
                  onPressed: () {
                    showCustomSheet(
                      context: context,
                      child: AvatarsSheet(
                        selectedAvatar: controller.selectedAvatar,
                        avatars: controller.globalController.userAvatars,
                      ),
                    );

                    controller.capturedImage.value = XFile('');
                    controller.selectedImage.value = const FilePickerResult([]);
                    controller.socialProfile.value = '';
                  },
                ),
                SizedBox(height: 20.sp),
                CustomButton(
                  width: Get.width * 0.9,
                  text: 'Capture with camera',
                  hasIcon: true,
                  color: context.theme.indicatorColor,
                  icon: IconTheme(
                    data: context.theme.iconTheme,
                    child: const Icon(
                      FlutterRemix.camera_3_fill,
                    ),
                  ),
                  onPressed: () async {
                    controller.capturedImage.value =
                        (await ImagePicker().pickImage(
                      source: ImageSource.camera,
                      imageQuality: 50,
                    ))!;
                    controller.selectedImage.value = const FilePickerResult([]);
                    controller.socialProfile.value = '';
                  },
                ),
                SizedBox(height: 20.sp),
                CustomButton(
                  width: Get.width * 0.9,
                  text: 'Choose from gallery',
                  hasIcon: true,
                  color: context.theme.indicatorColor,
                  icon: IconTheme(
                    data: context.theme.iconTheme,
                    child: const Icon(
                      FlutterRemix.image_2_fill,
                    ),
                  ),
                  onPressed: () async {
                    controller.selectedImage.value =
                        (await FilePicker.platform.pickFiles(
                      type: FileType.image,
                      withData: true,
                    ))!;
                    controller.capturedImage.value = XFile('');
                    controller.socialProfile.value = '';
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
