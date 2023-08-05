import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/models/user_model.dart';

import 'components/feeds_view.dart';
import 'components/info_view.dart';
import 'components/user_details.dart';

class UserProfileScreen extends HookWidget {
  final UserModel user;
  final ValueNotifier<int> followers;

  const UserProfileScreen(
      {super.key, required this.user, required this.followers});

  @override
  Widget build(BuildContext context) {
    final tabController = useTabController(initialLength: 2);

    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            UserDetails(user, tabController, followers.value),
          ];
        },
        body: TabBarView(
          controller: tabController,
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
