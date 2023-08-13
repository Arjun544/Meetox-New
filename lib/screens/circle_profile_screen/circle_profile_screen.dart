import 'package:meetox/controllers/circle_profile_controller.dart';
import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/models/circle_model.dart';
import 'package:meetox/widgets/mini_map.dart';
import 'package:meetox/widgets/read_more.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'components/circle_details.dart';

class CircleProfileScreen extends GetView<CircleProfileController> {
  final CircleModel circle;

  const CircleProfileScreen({super.key, required this.circle});

  @override
  Widget build(BuildContext context) {
    Get.put(CircleProfileController());
    controller.circle(circle);
    logSuccess(circle.toJson().toString());

    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      resizeToAvoidBottomInset: false,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            const CircleDetails(),
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
                  title: Obx(
                    () => ReadMoreText(
                      controller.profile.value.description?.capitalizeFirst ??
                          '',
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
                  child: Obx(
                    () => MiniMap(
                      latitude: circle.location!.latitude!,
                      longitude: circle.location!.longitude!,
                      image: controller.circle.value.photo!.obs,
                      color: Colors.lightBlue,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Column(
                children: [
                  Obx(
                    () => controller.profile.value.id == null
                        ? const SizedBox.shrink()
                        : Text(
                            'Created by ${controller.profile.value.admin!.id == currentUser.value.id ? 'YOU' : controller.profile.value.admin!.name!.capitalizeFirst!} ${timeago.format(
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
                      child: Obx(
                        () => Text(
                          'www.meetox.com/${controller.profile.value.name ?? ''}',
                          style: context.theme.textTheme.labelSmall,
                        ),
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
