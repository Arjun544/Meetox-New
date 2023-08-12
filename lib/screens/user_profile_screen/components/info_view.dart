import 'package:meetox/controllers/user_profile_controller.dart';
import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/widgets/mini_map.dart';
import 'package:timeago/timeago.dart' as timeago;

class InfoView extends GetView<UserProfileController> {
  const InfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              height: 200.h,
              width: Get.width,
              child: MiniMap(
                latitude: controller.user.value.location!.latitude!,
                longitude: controller.user.value.location!.longitude!,
                image: controller.user.value.photo!,
                color: AppColors.primaryYellow,
              ),
            ),
          ),
          Column(
            children: [
              Obx(
                () => controller.profile.value.id == null
                    ? const SizedBox.shrink()
                    : Text(
                        'Joined ${timeago.format(
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
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20.w),
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
                  Clipboard.setData(ClipboardData(
                      text: 'www.meetox.com/${controller.profile.value.name}'));
                  showToast('Copied profile link');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
