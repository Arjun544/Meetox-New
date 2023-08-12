import 'package:meetox/controllers/user_profile_controller.dart';
import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/models/user_model.dart';

import 'components/feeds_view.dart';
import 'components/info_view.dart';
import 'components/user_details.dart';

class UserProfileScreen extends GetView<UserProfileController> {
  final UserModel user;

  const UserProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    Get.put(UserProfileController());
    controller.userId(user.id!);

    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            UserDetails(user),
          ];
        },
        body: TabBarView(
          controller: controller.tabController,
          children: [
            InfoView(
              user: user,
            ),
            const FeedsView(),
          ],
        ),
      ),
    );
  }
}
