import 'package:meetox/controllers/my_followers_controller.dart';
import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/models/user_model.dart';
import 'package:meetox/widgets/custom_error_widget.dart';
import 'package:meetox/widgets/custom_field.dart';
import 'package:meetox/widgets/loaders/followers_loader.dart';

import '../../followers_screen/components/follower_tile.dart';

class MyFollowingsView extends GetView<MyFollowersController> {
  const MyFollowingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      color: AppColors.primaryYellow,
      onRefresh: () async => controller.followingPagingController.refresh(),
      child: Column(
        children: [
          SizedBox(height: 15.h),
          SizedBox(
            height: 40.h,
            child: CustomField(
              hintText: 'Search following',
              controller: TextEditingController(),
              focusNode: FocusNode(),
              isPasswordVisible: true.obs,
              hasFocus: false.obs,
              autoFocus: false,
              isSearchField: true,
              keyboardType: TextInputType.text,
              prefixIcon: FlutterRemix.search_2_fill,
              onChanged: (value) => controller.followingSearchQuery(value),
            ),
          ),
          SizedBox(height: 15.sp),
          Expanded(
            child: PagedListView.separated(
              pagingController: controller.followingPagingController,
              separatorBuilder: (context, index) => Divider(
                thickness: 1,
                color: context.theme.canvasColor.withOpacity(0.1),
              ),
              builderDelegate: PagedChildBuilderDelegate<UserModel>(
                animateTransitions: true,
                transitionDuration: const Duration(milliseconds: 300),
                firstPageProgressIndicatorBuilder: (_) =>
                    const FollowersLoader(hasCheckBox: false),
                newPageProgressIndicatorBuilder: (_) =>
                    const FollowersLoader(hasCheckBox: false),
                firstPageErrorIndicatorBuilder: (_) => Center(
                  child: CustomErrorWidget(
                    image: AssetsManager.angryState,
                    text: 'Failed to fetch following',
                    onPressed: controller.followingPagingController.refresh,
                  ),
                ),
                newPageErrorIndicatorBuilder: (_) => Center(
                  child: CustomErrorWidget(
                    image: AssetsManager.angryState,
                    text: 'Failed to fetch following',
                    onPressed: controller.followingPagingController.refresh,
                  ),
                ),
                noItemsFoundIndicatorBuilder: (_) => CustomErrorWidget(
                  image: AssetsManager.sadState,
                  text: 'No following found',
                  isWarining: true,
                  onPressed: () {},
                ),
                itemBuilder: (context, item, index) => FollowerTile(
                  user: item,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
