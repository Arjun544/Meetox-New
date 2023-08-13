import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:meetox/controllers/circle_profile_controller.dart';
import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/widgets/custom_area_field.dart';
import 'package:meetox/widgets/custom_button.dart';
import 'package:meetox/widgets/custom_field.dart';
import 'package:meetox/widgets/custom_sheet.dart';
import 'package:meetox/widgets/sheets/avatars_sheet.dart';
import 'package:meetox/widgets/unfocuser.dart';

class EditCircle extends GetView<CircleProfileController> {
  const EditCircle({super.key});

  @override
  Widget build(BuildContext context) {
    CircleProfileController controller = Get.find();
    final RxBool isLoading = false.obs;

    controller.socialProfile.value = controller.circle.value.photo!;
    controller.nameController.text = controller.profile.value.name!;
    controller.descController.text = controller.profile.value.description!;
    controller.isPrivate.value = controller.profile.value.isPrivate!;
    controller.nameText.value = controller.profile.value.name!;
    controller.descText.value = controller.profile.value.description!;

    return UnFocuser(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          title: Text(
            'Edit circle',
            style: context.theme.textTheme.labelMedium,
          ),
          actions: [
            Obx(
              () => Padding(
                padding: EdgeInsets.only(right: isLoading.value ? 24.0 : 8),
                child: isLoading.value
                    ? LoadingAnimationWidget.staggeredDotsWave(
                        color: AppColors.primaryYellow,
                        size: 20.sp,
                      )
                    : TextButton(
                        style: ElevatedButton.styleFrom(
                          splashFactory: NoSplash.splashFactory,
                        ),
                        onPressed: () => controller.handleEdit(isLoading),
                        child: Text(
                          'Done',
                          style: context.theme.textTheme.labelSmall!.copyWith(
                            color: controller.socialProfile.value !=
                                        controller.circle.value.photo ||
                                    controller.nameText.value.toLowerCase() !=
                                        controller.profile.value.name!
                                            .toLowerCase() ||
                                    controller.descText.value.toLowerCase() !=
                                        controller.profile.value.description!
                                            .toLowerCase() ||
                                    controller.isPrivate.value !=
                                        controller.profile.value.isPrivate
                                ? Colors.blueAccent
                                : Colors.blueGrey,
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
        body: Form(
          key: controller.editFormKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                Center(
                  child: Obx(
                    () => CircleAvatar(
                      maxRadius: 60.sp,
                      backgroundColor: Colors.blue,
                      backgroundImage: controller.socialProfile.value.isNotEmpty
                          ? CachedNetworkImageProvider(
                              controller.socialProfile.value)
                          : controller.selectedImage.value.files.isEmpty &&
                                  controller.capturedImage.value.path.isEmpty
                              ? AssetImage(
                                  controller.globalController.circleAvatars[
                                      controller.selectedAvatar.value],
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
                SizedBox(height: 30.sp),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                      width: Get.width * 0.15,
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
                            avatars: controller.globalController.circleAvatars,
                          ),
                        );
                        controller.capturedImage.value = XFile('');
                        controller.selectedImage.value =
                            const FilePickerResult([]);
                        controller.socialProfile.value = '';
                      },
                    ),
                    SizedBox(width: 20.w),
                    CustomButton(
                      width: Get.width * 0.15,
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
                        controller.selectedImage.value =
                            const FilePickerResult([]);
                        controller.socialProfile.value = '';
                      },
                    ),
                    SizedBox(width: 20.w),
                    CustomButton(
                      width: Get.width * 0.15,
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
                SizedBox(height: 40.h),
                Text(
                  'Name',
                  style: context.theme.textTheme.labelSmall,
                ),
                SizedBox(height: 10.h),
                CustomField(
                  hintText: 'Name',
                  autoFocus: false,
                  controller: controller.nameController,
                  focusNode: controller.nameFocusNode,
                  isPasswordVisible: true.obs,
                  hasFocus: controller.hasNameFocus,
                  formats: [
                    LengthLimitingTextInputFormatter(30),
                    FilteringTextInputFormatter.allow(
                      RegExp('[a-z A-Z á-ú Á-Ú 0-9 @.]'),
                    ),
                  ],
                  prefixIcon: FlutterRemix.record_circle_fill,
                  keyboardType: TextInputType.name,
                  onChanged: (value) => controller.nameText.value = value,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Name is required';
                    }
                    if (val.length < 2) {
                      return 'Enter at least 2 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.h),
                Text(
                  'Description',
                  style: context.theme.textTheme.labelSmall,
                ),
                SizedBox(height: 10.h),
                CustomAreaField(
                  hintText: 'Description',
                  text: controller.nameText,
                  controller: controller.descController,
                  focusNode: controller.descFocusNode,
                  hasFocus: controller.hasDescFocus,
                  formats: [
                    LengthLimitingTextInputFormatter(1000),
                    FilteringTextInputFormatter.allow(
                      RegExp('[a-z A-Z á-ú Á-Ú 0-9 @. \n]'),
                    ),
                  ],
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Description is required';
                    }
                    if (val.length < 2) {
                      return 'Enter at least 2 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Private',
                      style: context.theme.textTheme.labelLarge,
                    ),
                    Transform.scale(
                      scale: 0.7,
                      child: Obx(
                        () => CupertinoSwitch(
                          value: controller.isPrivate.value,
                          trackColor: Colors.black,
                          activeColor: AppColors.primaryYellow,
                          onChanged: (val) => controller.isPrivate.value = val,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
