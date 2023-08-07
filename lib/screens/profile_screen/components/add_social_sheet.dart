import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/helpers/get_social.dart';
import 'package:meetox/helpers/is_social_url.dart';
import 'package:meetox/models/user_model.dart';
import 'package:meetox/services/user_services.dart';
import 'package:meetox/widgets/custom_field.dart';

class AddSocialSheet extends HookWidget {
  final String type;

  const AddSocialSheet(this.type, {super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final linkController = useTextEditingController();
    final codeController = useTextEditingController(text: '+');
    final numberFocusNode = useFocusNode();
    final isLoading = useState(false);

    final addSocialMutation =
        useMutation<bool, dynamic, Map<String, dynamic>, dynamic>(
      CacheKeys.addSocial,
      (Map<String, dynamic> variables) async => await UserServices.addSocial(
        isLoading,
        variables['social'],
      ),
      onData: (data, recoveryData) {
        logSuccess(data.toString());
        if (data == true) {
          showToast('Link added');
          Navigator.pop(context);
          linkController.clear();
        }
      },
      onError: (error, recoveryData) {
        logError(error.toString());
        showToast('Link failed to add');
      },
    );

    return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
      return Container(
        height: isKeyboardVisible ? Get.height * 0.55 : Get.height * 0.25,
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        decoration: BoxDecoration(
          color: context.theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      linkController.clear();
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
                  isLoading.value
                      ? LoadingAnimationWidget.staggeredDotsWave(
                          color: AppColors.primaryYellow,
                          size: 20.sp,
                        )
                      : GestureDetector(
                          onTap: () async {
                            if (formKey.currentState!.validate()) {
                              await addSocialMutation.mutate({
                                'social': Social(
                                  type: type,
                                  url: type == 'whatsapp'
                                      ? codeController.text.trim() +
                                          linkController.text.trim()
                                      : linkController.text.trim(),
                                ),
                              });
                            }
                          },
                          child: Text(
                            'Save',
                            style: context.theme.textTheme.labelSmall!.copyWith(
                              color: Colors.blue,
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
                    controller: linkController,
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
                  ),
                )
              else
                PhoneFields(
                  codeController: codeController,
                  numberFocusNode: numberFocusNode,
                  type: type,
                  linkController: linkController,
                ),
            ],
          ),
        ),
      );
    });
  }
}

class PhoneFields extends StatelessWidget {
  const PhoneFields({
    super.key,
    required this.codeController,
    required this.numberFocusNode,
    required this.type,
    required this.linkController,
  });

  final TextEditingController codeController;
  final FocusNode numberFocusNode;
  final String type;
  final TextEditingController linkController;

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
            ),
          ),
        ),
      ],
    );
  }
}
