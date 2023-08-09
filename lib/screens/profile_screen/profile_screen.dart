import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/models/profile_model.dart';
import 'package:meetox/screens/circles_screen/circles_screen.dart';
import 'package:meetox/services/user_services.dart';
import 'package:meetox/widgets/loaders/list_tiles_loader.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'components/my_details.dart';

class ProfileScreen extends HookWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProfile = useQuery<ProfileModel, dynamic>(
      CacheKeys.userProfileDetails,
      () async => await UserServices.profileDetails(),
      onData: (value) {
        logError(value.toJson().toString());
      },
      onError: (error) {
        logError(error.toString());
      },
    );

    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      resizeToAvoidBottomInset: false,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            MyDetails(
              userProfile,
            ),
          ];
        },
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 24.h),
          child: userProfile.isLoading
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
                              userProfile.data!.crosspaths.toString(),
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
                              userProfile.data!.circles.toString(),
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
                              userProfile.data!.questions.toString(),
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
                        userProfile.data!.createdAt!,
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
    );
  }
}
