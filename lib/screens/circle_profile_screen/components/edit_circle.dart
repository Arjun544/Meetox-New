import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:meetox/controllers/circle_profile_controller.dart';
import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/helpers/get_asset_image.dart';
import 'package:meetox/models/circle_model.dart';
import 'package:meetox/services/circle_services.dart';
import 'package:meetox/widgets/custom_area_field.dart';
import 'package:meetox/widgets/custom_field.dart';
import 'package:meetox/widgets/custom_sheet.dart';
import 'package:meetox/widgets/unfocuser.dart';

import 'avatar_sheet.dart';

class EditCircle extends HookWidget {
  final ValueNotifier<CircleModel> circle;

  const EditCircle(this.circle, {super.key});

  @override
  Widget build(BuildContext context) {
    CircleProfileController controller = Get.find();
    final Rx<String> circleAvatar = circle.value.photo!.obs;
    final isLoading = useState(false);

    useEffect(() {
      controller.nameController.text = circle.value.name!;
      controller.descController.text = circle.value.description!;
      controller.isPrivate.value = circle.value.isPrivate!;
      controller.nameText.value = circle.value.name!;
      controller.descText.value = circle.value.description!;
      return () {};
    }, []);

   

    final editCircleMutation = useMutation(
      CacheKeys.addCircle,
      (Map<String, dynamic> variables) async => await CircleServices.editCircle(
        isLoading: isLoading,
        circle: variables['circle'],
      ),
      onData: (data, recoveryData) {
        // if (data.id != null) {
        //   controller.oData(data);
        // }
      },
      onError: (error, recoveryData) {
        logError(error.toString());
        showToast('Create circle failed');
      },
    );

    void handleDone() async {
      if ((circleAvatar.value != circle.value.photo ||
              controller.nameText.value.toLowerCase() !=
                  circle.value.name!.toLowerCase() ||
              controller.descText.value.toLowerCase() !=
                  circle.value.description!.toLowerCase() ||
              controller.isPrivate.value != circle.value.isPrivate) &&
          controller.editFormKey.currentState!.validate()) {
        File? base64Profile;
        if (controller.capturedImage.value.path.isEmpty &&
            controller.selectedImage.value.files.isNotEmpty) {
          base64Profile = File(controller.selectedImage.value.files[0].path!);
        }

        if (controller.selectedImage.value.files.isEmpty &&
            controller.capturedImage.value.path.isNotEmpty) {
          base64Profile = File(controller.capturedImage.value.path);
        }
        if (controller.selectedImage.value.files.isEmpty &&
            controller.capturedImage.value.path.isEmpty) {
          final imageFromAsset = await getImageFileFromAssets(
            controller.globalController
                .circleAvatars[controller.selectedAvatar.value],
          );
          log(imageFromAsset.path);

          base64Profile = File(imageFromAsset.path);
        }
        editCircleMutation.mutate(
          {
            'circle': CircleModel(
              id: circle.value.id,
              name: controller.nameController.text.trim(),
              description: controller.descController.text.trim(),
              isPrivate: controller.isPrivate.value,
            ),
            'file':
                circleAvatar.value != circle.value.photo ? base64Profile : null,
          },
        );
      }
    }

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
            Padding(
              padding: EdgeInsets.only(right: isLoading.value ? 24.0 : 8),
              child: isLoading.value
                  ? LoadingAnimationWidget.staggeredDotsWave(
                      color: Colors.blueAccent,
                      size: 20.w,
                    )
                  : TextButton(
                      style: ElevatedButton.styleFrom(
                        splashFactory: NoSplash.splashFactory,
                      ),
                      onPressed: () => handleDone(),
                      child: Obx(
                        () => Text(
                          'Done',
                          style: context.theme.textTheme.labelMedium!.copyWith(
                              color: circleAvatar.value != circle.value.photo ||
                                      controller.nameText.value.toLowerCase() !=
                                          circle.value.name!.toLowerCase() ||
                                      controller.descText.value.toLowerCase() !=
                                          circle.value.description!
                                              .toLowerCase() ||
                                      controller.isPrivate.value !=
                                          circle.value.isPrivate
                                  ? Colors.blueAccent
                                  : context.theme.indicatorColor),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20.h),
                GestureDetector(
                  onTap: () => showCustomSheet(
                    context: context,
                    child: AvatarSheet(circleAvatar),
                  ),
                  // child: Obx(
                  //   () => CircleAvatar(
                  //     maxRadius: 85.sp,
                  //     backgroundColor: AppColors.primaryYellow,
                  //     backgroundImage: controller
                  //                 .selectedImage.value.files.isEmpty &&
                  //             controller.capturedImage.value.path.isEmpty
                  //         ? CachedNetworkImageProvider(
                  //             circle.value.image!.image!,
                  //           )
                  //         : (controller.selectedImage.value.files.isNotEmpty &&
                  //                 controller.capturedImage.value.path.isNotEmpty
                  //             ? AssetImage(
                  //                 controller.globalController.circleAvatars[
                  //                     controller.selectedAvatar.value],
                  //               )
                  //             : controller.selectedImage.value.files.isEmpty
                  //                 ? Image.file(
                  //                     File(controller.capturedImage.value.path),
                  //                   ).image
                  //                 : Image.file(
                  //                     File(controller
                  //                         .selectedImage.value.files[0].path!),
                  //                   ).image),
                  //   ),
                  // ),
                  child: Obx(
                    () => Container(
                      height: Get.height * 0.1,
                      width: Get.width * 0.2,
                      decoration: BoxDecoration(
                        color: context.theme.indicatorColor,
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: circleAvatar.value.isNotEmpty
                              ? CachedNetworkImageProvider(
                                  circle.value.photo!,
                                )
                              : controller.selectedImage.value.files.isEmpty &&
                                      controller
                                          .capturedImage.value.path.isEmpty
                                  ? AssetImage(
                                      controller.globalController.circleAvatars[
                                          controller.selectedAvatar.value],
                                    )
                                  : controller.selectedImage.value.files.isEmpty
                                      ? Image.file(
                                          File(controller
                                              .capturedImage.value.path),
                                        ).image
                                      : Image.file(
                                          File(controller.selectedImage.value
                                              .files[0].path!),
                                        ).image,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40.h),
                CustomField(
                  hintText: 'Name',
                  autoFocus: true,
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
                SizedBox(height: 15.h),
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
