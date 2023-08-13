import 'package:flutter/cupertino.dart';
import 'package:meetox/controllers/circle_profile_controller.dart';
import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/widgets/custom_button.dart';
import 'package:meetox/widgets/custom_sheet.dart';

import 'add_member_sheet.dart';
import 'edit_circle.dart';

class AdminOptions extends GetView<CircleProfileController> {
  const AdminOptions({super.key});

  @override
  Widget build(BuildContext context) {
    final RxBool isLoading = false.obs;

    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomButton(
            width: Get.width * 0.15,
            height: 35.h,
            color: context.theme.indicatorColor,
            icon: const Icon(
              IconsaxBold.edit_2,
            ),
            onPressed: () => Get.to(
              () => const EditCircle(),
            ),
          ),
          VerticalDivider(
            color: context.theme.indicatorColor,
            width: 40.w,
            thickness: 2,
            indent: 5.h,
            endIndent: 5.h,
          ),
          CustomButton(
            width: Get.width * 0.15,
            height: 35.h,
            color: context.theme.indicatorColor,
            icon: const Icon(
              IconsaxBold.user_add,
            ),
            onPressed: () => showCustomSheet(
              context: context,
              child: const AddMemberSheet(),
            ),
          ),
          VerticalDivider(
            color: context.theme.indicatorColor,
            width: 40.w,
            thickness: 2,
            indent: 5.h,
            endIndent: 5.h,
          ),
          CustomButton(
            width: Get.width * 0.15,
            height: 35.h,
            color: context.theme.indicatorColor,
            icon: const Icon(
              IconsaxBold.trash,
              color: Colors.redAccent,
            ),
            onPressed: () => showCupertinoModalPopup(
              context: context,
              builder: (context) => CupertinoActionSheet(
                title: Text(
                  'Are you sure?',
                  style: context.theme.textTheme.labelMedium,
                ),
                cancelButton: CupertinoActionSheetAction(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: context.theme.textTheme.labelMedium,
                  ),
                ),
                actions: [
                  Obx(
                    () => isLoading.value
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Get.width * 0.44, vertical: 8.h),
                            child: LoadingAnimationWidget.staggeredDotsWave(
                              color: AppColors.primaryYellow,
                              size: 20.sp,
                            ),
                          )
                        : CupertinoActionSheetAction(
                            isDestructiveAction: true,
                            onPressed: () => controller.handleDelete(isLoading),
                            child: Text(
                              'Delete',
                              style:
                                  context.theme.textTheme.labelMedium!.copyWith(
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
