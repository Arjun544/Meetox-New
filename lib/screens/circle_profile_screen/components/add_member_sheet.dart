import 'package:meetox/controllers/circle_profile_controller.dart';
import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/models/user_model.dart';
import 'package:meetox/widgets/close_button.dart';
import 'package:meetox/widgets/custom_error_widget.dart';
import 'package:meetox/widgets/custom_field.dart';
import 'package:meetox/widgets/loaders/followers_loader.dart';

import 'follower_tile.dart';

class AddMemberSheet extends GetView<CircleProfileController> {
  const AddMemberSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.9,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      decoration: BoxDecoration(
        color: context.theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(
                () => Text(
                  'Add members ( ${controller.members.value}/${controller.circle.value.limit} )',
                  style: context.theme.textTheme.labelLarge,
                ),
              ),
              CustomCloseButton(
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
          SizedBox(height: 30.h),
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
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
