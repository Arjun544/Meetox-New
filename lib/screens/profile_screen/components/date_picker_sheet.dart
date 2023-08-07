import 'package:flutter/cupertino.dart';
import 'package:meetox/models/profile_model.dart';
import 'package:meetox/services/user_services.dart';

import '../../../core/imports/core_imports.dart';
import '../../../core/imports/packages_imports.dart';

class DatePickerSheet extends HookWidget {
  final ValueNotifier<DateTime> selectedDate;
  final Query<ProfileModel, dynamic> userProfile;

  const DatePickerSheet(
      {super.key, required this.selectedDate, required this.userProfile});
  @override
  Widget build(BuildContext context) {
    final isLoading = useState(false);
    final newDOB = useState(selectedDate.value);

    final changeDOBMutation =
        useMutation<bool, dynamic, Map<String, dynamic>, dynamic>(
      CacheKeys.addSocial,
      (Map<String, dynamic> variables) async => await UserServices.updateDOB(
        isLoading,
        variables['date'],
      ),
      onData: (data, recoveryData) {
        logSuccess(data.toString());
        if (data == true) {
          userProfile.setData(ProfileModel(
            id: userProfile.data!.id,
            feeds: userProfile.data!.feeds,
            circles: userProfile.data!.circles,
            followers: userProfile.data!.followers,
            followings: userProfile.data!.followings,
            crosspaths: userProfile.data!.crosspaths,
            questions: userProfile.data!.questions,
            createdAt: userProfile.data!.createdAt,
            dob: newDOB.value,
          ));
          Navigator.pop(context);
        }
      },
      onError: (error, recoveryData) {
        logError(error.toString());
        showToast('Link failed to add');
      },
    );

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
                onTap: () {
                  Navigator.pop(context);
                },
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
              isLoading.value
                  ? LoadingAnimationWidget.staggeredDotsWave(
                      color: AppColors.primaryYellow,
                      size: 20.sp,
                    )
                  : GestureDetector(
                      onTap: () async {
                        if (newDOB.value.day != selectedDate.value.day ||
                            newDOB.value.month != selectedDate.value.month ||
                            newDOB.value.year != selectedDate.value.year) {
                          await changeDOBMutation.mutate({
                            'date': newDOB.value,
                          });
                        }
                      },
                      child: Text(
                        'Save',
                        style: context.theme.textTheme.labelSmall!.copyWith(
                          color: newDOB.value.day == selectedDate.value.day &&
                                  newDOB.value.month ==
                                      selectedDate.value.month &&
                                  newDOB.value.year == selectedDate.value.year
                              ? Colors.grey
                              : Colors.blue,
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
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: selectedDate.value,
                maximumDate:
                    DateTime.now().subtract(const Duration(days: 2922)),
                minimumDate: selectedDate.value
                    .subtract(const Duration(days: 36525)), // 100 years
                dateOrder: DatePickerDateOrder.dmy,
                onDateTimeChanged: (date) => newDOB.value = date,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
