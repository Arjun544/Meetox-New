import 'package:meetox/controllers/circle_profile_controller.dart';
import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/models/circle_model.dart';
import 'package:meetox/models/user_model.dart';
import 'package:meetox/services/user_services.dart';
import 'package:meetox/widgets/mini_map.dart';
import 'package:meetox/widgets/read_more.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'components/circle_details.dart';

class CircleProfileScreen extends HookWidget {
  final CircleModel circle;
  final ValueNotifier<int> allMembers;

  const CircleProfileScreen(
      {super.key, required this.circle, required this.allMembers});

  @override
  Widget build(BuildContext context) {
    Get.put(CircleProfileController());
    final ValueNotifier<CircleModel> profileCircle = useState(circle);

    final adminResult = useQuery<UserModel, dynamic>(
      CacheKeys.currentUser,
      () async => await UserServices.userById(
        id: circle.adminId,
      ),
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
            CircleDetails(profileCircle, allMembers),
          ];
        },
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15.w),
                decoration: BoxDecoration(
                  color: context.theme.indicatorColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: ReadMoreText(
                    '', // "${profileCircle.value.description!.capitalizeFirst!}Amet pariatur irure velit non sit dolore est. Ipsum nulla ad cillum aliquip velit labore reprehenderit ut duis. Esse adipisicing nulla deserunt pariatur anim quis aliquip. Ut Lorem aute voluptate fugiat mollit quis est labore quis commodo elit consequat non. Sunt ad nulla proident ex dolor ea veniam. Duis proident anim ut laboris incididunt est laboris amet ullamco deserunt dolore.",
                    style: context.theme.textTheme.labelSmall,
                    trimLines: 3,
                    colorClickableText: Colors.redAccent,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: ' Read more',
                    trimExpandedText: ' Read less',
                    moreStyle: context.theme.textTheme.labelSmall!.copyWith(
                      color: Colors.blueAccent,
                    ),
                  ),
                  splashColor: Colors.transparent,
                ),
              ),
              SizedBox(height: 20.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  height: 200.h,
                  width: Get.width,
                  child: MiniMap(
                    latitude: circle.location!.latitude!,
                    longitude: circle.location!.longitude!,
                    image: circle.photo!,
                    color: Colors.lightBlue,
                  ),
                ),
              ),
              const Spacer(),
              Column(
                children: [
                  adminResult.isLoading
                      ? const SizedBox.shrink()
                      : Text(
                          'Created by ${circle.adminId == currentUser.value.id ? 'YOU' : adminResult.data!.name!.capitalizeFirst!} ${timeago.format(
                            circle.createdAt!,
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
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20.w),
                      decoration: BoxDecoration(
                        color: context.theme.indicatorColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'www.meetox.com/${circle.name}',
                        style: context.theme.textTheme.labelSmall,
                      ),
                    ),
                    trailing: const Icon(IconsaxBold.copy),
                    splashColor: Colors.transparent,
                    onTap: () {
                      Clipboard.setData(
                          ClipboardData(text: 'www.meetox.com/${circle.name}'));
                      showToast('Copied profile link');
                    },
                  ),
                ],
              ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}
