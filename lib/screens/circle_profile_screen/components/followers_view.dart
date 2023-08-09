import 'package:meetox/controllers/circle_profile_controller.dart';
import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/models/user_model.dart';
import 'package:meetox/widgets/custom_error_widget.dart';
import 'package:meetox/widgets/custom_field.dart';
import 'package:meetox/widgets/loaders/followers_loader.dart';

import 'follower_tile.dart';

class FollowersView extends GetView<CircleProfileController> {
  final String id;
  final ValueNotifier<int> members;
  final bool isPrivate;
  final int limit;

  const FollowersView(
      {super.key,
      required this.id,
      required this.members,
      required this.isPrivate,
      required this.limit});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      color: AppColors.primaryYellow,
      onRefresh: () async => controller.followersPagingController.refresh(),
      child: Column(
        children: [
          SizedBox(height: 15.h),
          SizedBox(
            height: 40.h,
            child: CustomField(
              hintText: 'Search followers',
              controller: TextEditingController(),
              focusNode: FocusNode(),
              isPasswordVisible: true.obs,
              hasFocus: false.obs,
              autoFocus: false,
              isSearchField: true,
              keyboardType: TextInputType.text,
              prefixIcon: FlutterRemix.search_2_fill,
              onChanged: (value) => controller.followersSearchQuery(value),
            ),
          ),
          SizedBox(height: 15.sp),
          Expanded(
            child: PagedListView.separated(
              pagingController: controller.followersPagingController,
              separatorBuilder: (context, index) => Divider(
                thickness: 1,
                color: context.theme.canvasColor.withOpacity(0.1),
              ),
              builderDelegate: PagedChildBuilderDelegate<UserModel>(
                animateTransitions: true,
                transitionDuration: const Duration(milliseconds: 500),
                firstPageProgressIndicatorBuilder: (_) =>
                    const FollowersLoader(hasCheckBox: false),
                newPageProgressIndicatorBuilder: (_) =>
                    const FollowersLoader(hasCheckBox: false),
                firstPageErrorIndicatorBuilder: (_) => Center(
                  child: CustomErrorWidget(
                    image: AssetsManager.angryState,
                    text: 'Failed to fetch followers',
                    onPressed: controller.followersPagingController.refresh,
                  ),
                ),
                newPageErrorIndicatorBuilder: (_) => Center(
                  child: CustomErrorWidget(
                    image: AssetsManager.angryState,
                    text: 'Failed to fetch followers',
                    onPressed: controller.followersPagingController.refresh,
                  ),
                ),
                noItemsFoundIndicatorBuilder: (_) => CustomErrorWidget(
                  image: AssetsManager.sadState,
                  text: 'No followers found',
                  isWarining: true,
                  onPressed: () {},
                ),
                itemBuilder: (context, item, index) => FollowerTile(
                  user: item,
                  id: id,
                  members: members,
                  isPrivate: isPrivate,
                  limit: limit,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
