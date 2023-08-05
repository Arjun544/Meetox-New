import 'package:meetox/controllers/followers_controller.dart';
import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/models/user_model.dart';
import 'package:meetox/widgets/custom_tabbar.dart';

import 'components/followers_view.dart';
import 'components/following_view.dart';

class FollowersScreen extends GetView<FollowersController> {
  final UserModel user;
  final bool isFollowing;

  const FollowersScreen(this.user, this.isFollowing, {super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(FollowersController(user.id!, isFollowing));

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          user.name!.capitalizeFirst!,
          style: context.theme.textTheme.labelMedium,
        ),
        leading: InkWell(
          onTap: Get.back,
          child: Icon(FlutterRemix.arrow_left_s_line, size: 25.sp),
        ),
        iconTheme: context.theme.appBarTheme.iconTheme,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            SizedBox(height: 15.sp),
            CustomTabbar(
              controller: controller.tabController,
              tabs: const [
                Text('Followers'),
                Text('Following'),
              ],
              onTap: (int page) {},
            ),
            Expanded(
              child: TabBarView(
                controller: controller.tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  FollowersView(),
                  FollowingView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
