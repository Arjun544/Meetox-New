import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/models/user_model.dart';
import 'package:meetox/widgets/mini_map.dart';
import 'package:timeago/timeago.dart' as timeago;

class InfoView extends StatelessWidget {
  final UserModel user;

  const InfoView({super.key, required this.user});

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
                latitude: currentUser.value.location!.latitude!,
                longitude: currentUser.value.location!.longitude!,
                image: currentUser.value.photo!,
                color: AppColors.primaryYellow,
              ),
            ),
          ),
          Column(
            children: [
              Text(
                'Joined ${timeago.format(
                  user.createdAt!,
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
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20.w),
                  decoration: BoxDecoration(
                    color: context.theme.indicatorColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'www.meetox.com/${user.name}',
                    style: context.theme.textTheme.labelSmall,
                  ),
                ),
                trailing: const Icon(IconsaxBold.copy),
                splashColor: Colors.transparent,
                onTap: () {
                  Clipboard.setData(
                      ClipboardData(text: 'www.meetox.com/${user.name}'));
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
