import 'package:meetox/controllers/my_followers_controller.dart';
import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/widgets/custom_tabbar.dart';

import 'components/my_followers_view.dart';
import 'components/my_followings_view.dart';

class MyFollowersScreen extends GetView<MyFollowersController> {
  final bool isFollowing;

  const MyFollowersScreen(this.isFollowing, {super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(MyFollowersController());
    controller.currentIndex.value = isFollowing ? 1 : 0;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Obx(
          () => Text(
            currentUser.value.name!.capitalizeFirst!,
            style: context.theme.textTheme.labelMedium,
          ),
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
                  MyFollowersView(),
                  MyFollowingsView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
