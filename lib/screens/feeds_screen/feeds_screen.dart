import 'package:meetox/controllers/feeds_controller.dart';
import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/models/feed_model.dart';
import 'package:meetox/widgets/custom_error_widget.dart';
import 'package:meetox/widgets/custom_tabbar.dart';
import 'package:meetox/widgets/loaders/circles_loader.dart';
import 'package:meetox/widgets/top_bar.dart';

import '../../core/imports/core_imports.dart';
import 'components/feed_tile.dart';

class FeedScreen extends GetView<FeedsController> {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(FeedsController());
    return Scaffold(
      body: RefreshIndicator(
        backgroundColor: context.theme.scaffoldBackgroundColor,
        color: AppColors.primaryYellow,
        onRefresh: () async {
          if (!controller.tabController.indexIsChanging) {
            if (controller.tabController.index == 1) {
              controller.recentPagingController.refresh();
            } else {
              controller.nearbyPagingController.refresh();
            }
          }
        },
        child: Column(
          children: [
            TopBar(
              isPrecise: controller.rootController.isLocationPrecise,
            ),
            SizedBox(height: 10.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Your feeds',
                    style: context.theme.textTheme.titleMedium,
                  ),
                  SizedBox(
                    width: 100.w,
                    height: 35.h,
                    child: CustomTabbar(
                      controller: controller.tabController,
                      tabs: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 14.w),
                          child: Icon(
                            IconsaxBold.clock,
                            size: 18.w,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 14.w),
                          child: Icon(
                            IconsaxBold.location,
                            size: 18.w,
                          ),
                        ),
                      ],
                      onTap: (value) {},
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: controller.tabController,
                children: [
                  PagedListView(
                    pagingController: controller.recentPagingController,
                    padding:
                        EdgeInsets.only(top: 10.h, bottom: Get.height * 0.12),
                    builderDelegate: PagedChildBuilderDelegate<FeedModel>(
                      animateTransitions: true,
                      transitionDuration: const Duration(milliseconds: 300),
                      firstPageProgressIndicatorBuilder: (_) =>
                          const CirclesLoader(),
                      newPageProgressIndicatorBuilder: (_) =>
                          const CirclesLoader(),
                      firstPageErrorIndicatorBuilder: (_) => Center(
                        child: CustomErrorWidget(
                          image: AssetsManager.angryState,
                          text: 'Failed to fetch feeds',
                          onPressed: controller.recentPagingController.refresh,
                        ),
                      ),
                      newPageErrorIndicatorBuilder: (_) => Center(
                        child: CustomErrorWidget(
                          image: AssetsManager.angryState,
                          text: 'Failed to fetch feeds',
                          onPressed: controller.recentPagingController.refresh,
                        ),
                      ),
                      noItemsFoundIndicatorBuilder: (_) => CustomErrorWidget(
                        image: AssetsManager.sadState,
                        text: 'No recent feeds found',
                        btnText: 'Find nearby',
                        onPressed: () =>
                            controller.rootController.selectedTab.value = 0,
                      ),
                      itemBuilder: (context, item, index) => FeedTile(
                        feed: item,
                      ),
                    ),
                  ),
                  PagedListView(
                    pagingController: controller.nearbyPagingController,
                    padding:
                        EdgeInsets.only(top: 10.h, bottom: Get.height * 0.12),
                    builderDelegate: PagedChildBuilderDelegate<FeedModel>(
                      animateTransitions: true,
                      transitionDuration: const Duration(milliseconds: 300),
                      firstPageProgressIndicatorBuilder: (_) =>
                          const CirclesLoader(),
                      newPageProgressIndicatorBuilder: (_) =>
                          const CirclesLoader(),
                      firstPageErrorIndicatorBuilder: (_) => Center(
                        child: CustomErrorWidget(
                          image: AssetsManager.angryState,
                          text: 'Failed to fetch feeds',
                          onPressed: controller.nearbyPagingController.refresh,
                        ),
                      ),
                      newPageErrorIndicatorBuilder: (_) => Center(
                        child: CustomErrorWidget(
                          image: AssetsManager.angryState,
                          text: 'Failed to fetch feeds',
                          onPressed: controller.nearbyPagingController.refresh,
                        ),
                      ),
                      noItemsFoundIndicatorBuilder: (_) => CustomErrorWidget(
                        image: AssetsManager.sadState,
                        text: 'No nearby feeds found',
                        btnText: 'Find nearby',
                        onPressed: () =>
                            controller.rootController.selectedTab.value = 0,
                      ),
                      itemBuilder: (context, item, index) => FeedTile(
                        feed: item,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
