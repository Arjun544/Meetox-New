import 'package:meetox/controllers/my_profile_controller.dart';
import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/helpers/get_social.dart';
import 'package:meetox/helpers/is_social_url.dart';
import 'package:meetox/widgets/custom_field.dart';

class AddSocialSheet extends GetView<MyProfileController> {
  final String type;
  final String? url;

  const AddSocialSheet(this.type, {this.url, super.key});

  @override
  Widget build(BuildContext context) {
    if (url != null) {
      if (!url.toString().isPhoneNumber) {
        controller.linkController.text = url!;
        controller.linkTextInput.value = url!;
      } else {
        controller.linkController.text = url!.substring(3);
        controller.linkTextInput.value = url!.substring(3);
        controller.codeController.text = url!.substring(0, 3);
      }
    }

    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        return Container(
          height: isKeyboardVisible ? Get.height * 0.6 : Get.height * 0.25,
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          decoration: BoxDecoration(
            color: context.theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Form(
            key: controller.socialFormKey,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        controller.linkController.clear();
                      },
                      child: Text(
                        'Cancel',
                        style: context.theme.textTheme.labelSmall!.copyWith(
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                    Text(
                      'Add ${type.capitalizeFirst!}',
                      style: context.theme.textTheme.labelMedium,
                    ),
                    Obx(
                      () => controller.isLoading.value
                          ? LoadingAnimationWidget.staggeredDotsWave(
                              color: AppColors.primaryYellow,
                              size: 20.sp,
                            )
                          : GestureDetector(
                              onTap: () async {
                                if (controller.socialFormKey.currentState!
                                    .validate()) {
                                  if (url == null &&
                                      controller.linkTextInput.value != url) {
                                    controller.handleAddSocial(
                                      context,
                                      type: type,
                                      url: type == 'whatsapp'
                                          ? controller.codeController.text
                                                  .trim() +
                                              controller.linkController.text
                                                  .trim()
                                          : controller.linkController.text
                                              .trim(),
                                    );
                                  } else {
                                    currentUser.value.socials!.removeWhere(
                                        (element) => element.type == type);
                                    controller.handleAddSocial(
                                      context,
                                      type: type,
                                      url: type == 'whatsapp'
                                          ? controller.codeController.text
                                                  .trim() +
                                              controller.linkController.text
                                                  .trim()
                                          : controller.linkController.text
                                              .trim(),
                                    );
                                  }
                                }
                              },
                              child: Text(
                                'Save',
                                style: context.theme.textTheme.labelSmall!
                                    .copyWith(
                                  color: controller.linkTextInput.value == url
                                      ? Colors.grey
                                      : Colors.blue,
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
                SizedBox(height: 30.h),
                if (type != 'whatsapp')
                  SizedBox(
                    width: Get.width,
                    height: 70.h,
                    child: CustomField(
                      hintText: 'Link',
                      controller: controller.linkController,
                      focusNode: FocusNode(),
                      keyboardType: TextInputType.url,
                      isPasswordVisible: true.obs,
                      hasFocus: false.obs,
                      prefixIcon: getSocial(type),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Link is required';
                        } else if (!isValidSocialUrl(type, value.trim())) {
                          return 'Invalid ${type.capitalizeFirst} url';
                        }
                        return null;
                      },
                      onChanged: (value) =>
                          controller.linkTextInput.value = value,
                    ),
                  )
                else
                  PhoneFields(
                    codeController: controller.codeController,
                    numberFocusNode: controller.numberFocusNode,
                    type: type,
                    linkController: controller.linkController,
                    linkTextInput: controller.linkTextInput,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class PhoneFields extends StatelessWidget {
  const PhoneFields({
    super.key,
    required this.codeController,
    required this.numberFocusNode,
    required this.type,
    required this.linkController,
    required this.linkTextInput,
  });

  final TextEditingController codeController;
  final FocusNode numberFocusNode;
  final String type;
  final TextEditingController linkController;
  final RxString linkTextInput;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 70.h,
            child: CustomField(
              hintText: '+92',
              controller: codeController,
              focusNode: FocusNode(),
              keyboardType: TextInputType.phone,
              isPasswordVisible: true.obs,
              hasFocus: true.obs,
              validator: (value) {
                if (value!.isEmpty) {
                  return '';
                } else if (!isValidSocialUrl(type, value.trim())) {
                  return '';
                }
                return null;
              },
              onChanged: (value) {
                linkTextInput.value = value;
                if (value.length == 3) {
                  numberFocusNode.requestFocus();
                }
              },
            ),
          ),
        ),
        SizedBox(width: 20.w),
        Expanded(
          flex: 3,
          child: SizedBox(
            height: 70.h,
            child: CustomField(
              hintText: '345 656789',
              controller: linkController,
              focusNode: numberFocusNode,
              keyboardType: TextInputType.number,
              isPasswordVisible: true.obs,
              hasFocus: false.obs,
              autoFocus: false,
              prefixIcon: getSocial(type),
              formats: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(11),
              ],
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Number is required';
                } else if (!isValidSocialUrl(type, value.trim())) {
                  return 'Invalid ${type.capitalizeFirst} number';
                }
                return null;
              },
              onChanged: (value) => linkTextInput.value = value,
            ),
          ),
        ),
      ],
    );
  }
}
