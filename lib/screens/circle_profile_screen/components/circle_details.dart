import 'package:cached_network_image/cached_network_image.dart';
import 'package:meetox/controllers/circle_profile_controller.dart';
import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/widgets/loaders/socials_loaders.dart';

import 'admin_options.dart';
import 'non_admin_options.dart';

class CircleDetails extends GetView<CircleProfileController> {
  const CircleDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      elevation: 0.1,
      expandedHeight: Get.height * 0.3,
      pinned: true,
      title: Obx(
        () => Text(
          controller.profile.value.name?.capitalizeFirst ?? '',
          style: context.theme.textTheme.labelMedium,
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Padding(
          padding: EdgeInsets.only(top: Get.height * 0.15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Obx(
                    () => Container(
                      height: Get.height * 0.09,
                      width: Get.width * 0.18,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(
                            controller.circle.value.photo!,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Get.to(() => MembersScreen(circle.value));
                    },
                    child: Column(
                      children: [
                        Obx(
                          () => Text(
                            controller.profile.value.members == null
                                ? '0'
                                : controller.profile.value.members.toString(),
                            style: context.theme.textTheme.labelMedium,
                          ),
                        ),
                        Text(
                          'Members',
                          style: context.theme.textTheme.labelSmall!
                              .copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Obx(
                        () => Text(
                          controller.profile.value.limit == null
                              ? '0'
                              : controller.profile.value.limit.toString(),
                          style: context.theme.textTheme.labelMedium,
                        ),
                      ),
                      Text(
                        'Limit',
                        style: context.theme.textTheme.labelSmall!
                            .copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 30.h),
              Obx(
                () => controller.profile.value.id != null
                    ? controller.profile.value.isPrivate == false &&
                            !(controller.profile.value.admin!.id ==
                                currentUser.value.id)
                        ? const NonAdminOptions()
                        : const AdminOptions()
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SocialsLoaders(),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
