import 'package:meetox/controllers/profile_controller.dart';
import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/screens/circles_screen/circles_screen.dart';
import 'package:meetox/widgets/loaders/list_tiles_loader.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'components/my_details.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ProfileController());

    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      resizeToAvoidBottomInset: false,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            const MyDetails(),
          ];
        },
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 24.h),
          child: Obx(
            () => controller.isLoading.value
                ? const ListTilesLoader()
                : Column(
                    children: [
                      ListTile(
                        minLeadingWidth: 0,
                        leading: const Icon(
                          FlutterRemix.footprint_fill,
                          color: AppColors.customBlack,
                        ),
                        title: Text(
                          'Cross paths',
                          style: context.theme.textTheme.labelMedium,
                        ),
                        trailing: SizedBox(
                          width: 40.w,
                          child: Row(
                            children: [
                              Text(
                                controller.profile.value.crosspaths.toString(),
                                style: context.theme.textTheme.labelMedium,
                              ),
                              SizedBox(width: 10.w),
                              const Icon(FlutterRemix.arrow_right_s_line),
                            ],
                          ),
                        ),
                      ),
                      ListTile(
                        onTap: () => Get.to(() => const CirclesScreen()),
                        minLeadingWidth: 0,
                        leading: const Icon(
                          FlutterRemix.bubble_chart_fill,
                          color: Colors.lightBlue,
                        ),
                        title: Text(
                          'Circles',
                          style: context.theme.textTheme.labelMedium,
                        ),
                        trailing: SizedBox(
                          width: 40.w,
                          child: Row(
                            children: [
                              Text(
                                controller.profile.value.circles.toString(),
                                style: context.theme.textTheme.labelMedium,
                              ),
                              SizedBox(width: 10.w),
                              const Icon(FlutterRemix.arrow_right_s_line),
                            ],
                          ),
                        ),
                      ),
                      ListTile(
                        minLeadingWidth: 0,
                        leading: const Icon(
                          FlutterRemix.question_fill,
                          color: Colors.green,
                        ),
                        title: Text(
                          'Questions',
                          style: context.theme.textTheme.labelMedium,
                        ),
                        trailing: SizedBox(
                          width: 40.w,
                          child: Row(
                            children: [
                              Text(
                                controller.profile.value.questions.toString(),
                                style: context.theme.textTheme.labelMedium,
                              ),
                              SizedBox(width: 10.w),
                              const Icon(FlutterRemix.arrow_right_s_line),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Joined Meetox ${timeago.format(
                          controller.profile.value.createdAt!,
                          locale: 'en',
                          allowFromNow: true,
                        )}',
                        style: context.theme.textTheme.labelSmall!.copyWith(
                          color: context.theme.textTheme.labelSmall!.color!
                              .withOpacity(0.5),
                          letterSpacing: 1,
                        ),
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
