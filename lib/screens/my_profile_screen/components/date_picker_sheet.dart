import 'package:flutter/cupertino.dart';
import 'package:meetox/controllers/my_profile_controller.dart';

import '../../../core/imports/core_imports.dart';
import '../../../core/imports/packages_imports.dart';

class DatePickerSheet extends GetView<MyProfileController> {
  const DatePickerSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final Rx<DateTime> newDOB = controller.selectedDOB.value.obs;

    return Container(
      width: Get.width,
      height: Get.height * 0.6,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      decoration: BoxDecoration(
        color: context.theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: context.theme.textTheme.labelSmall!.copyWith(
                    color: Colors.redAccent,
                  ),
                ),
              ),
              Text(
                'Change date',
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
                          if (newDOB.value.day !=
                                  controller.selectedDOB.value.day ||
                              newDOB.value.month !=
                                  controller.selectedDOB.value.month ||
                              newDOB.value.year !=
                                  controller.selectedDOB.value.year) {
                            controller.selectedDOB(newDOB.value);
                            controller.handleChangeDOB(context);
                          }
                        },
                        child: Text(
                          'Save',
                          style: context.theme.textTheme.labelSmall!.copyWith(
                            color: newDOB.value.day ==
                                        controller.selectedDOB.value.day &&
                                    newDOB.value.month ==
                                        controller.selectedDOB.value.month &&
                                    newDOB.value.year ==
                                        controller.selectedDOB.value.year
                                ? Colors.grey
                                : Colors.blue,
                          ),
                        ),
                      ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Expanded(
            child: CupertinoTheme(
              data: CupertinoThemeData(
                textTheme: CupertinoTextThemeData(
                  pickerTextStyle: context.theme.textTheme.labelSmall,
                ),
              ),
              child: Obx(
                () => CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: controller.selectedDOB.value,
                  maximumDate:
                      DateTime.now().subtract(const Duration(days: 2922)),
                  minimumDate: controller.selectedDOB.value
                      .subtract(const Duration(days: 36525)), // 100 years
                  dateOrder: DatePickerDateOrder.dmy,
                  onDateTimeChanged: (date) => newDOB.value = date,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
