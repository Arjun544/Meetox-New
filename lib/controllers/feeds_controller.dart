import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/models/feed_model.dart';
import 'package:meetox/services/feed_services.dart';

import '../core/imports/core_imports.dart';
import 'root_controller.dart';

class FeedsController extends GetxController with GetTickerProviderStateMixin {
  final RootController rootController = Get.find();

  final nearbyPagingController =
      PagingController<int, FeedModel>(firstPageKey: 1);

  final recentPagingController =
      PagingController<int, FeedModel>(firstPageKey: 1);

  late TabController tabController;
  final RxInt selectedFilter = 0.obs;

  @override
  void onInit() async {
    nearbyPagingController.addPageRequestListener((page) async {
      await fetchNearbyFeeds(page);
    });
    recentPagingController.addPageRequestListener((page) async {
      await fetchRecentFeeds(page);
    });
    tabController = TabController(length: 2, vsync: this);
    super.onInit();
  }

  Future<void> fetchNearbyFeeds(int pageKey) async {
    try {
      final newPage = await FeedServices.getNearByFeeds(
        limit: pageKey,
        lat: currentUser.value.location!.latitude!,
        long: currentUser.value.location!.longitude!,
      );

      final newItems = newPage;
      final hasNextPage = newPage.isEmpty;

      if (!hasNextPage) {
        nearbyPagingController.appendLastPage(newItems);
      } else if (hasNextPage) {
        nearbyPagingController.appendPage(newItems, pageKey + 1);
      }
    } catch (e) {
      logError(e.toString());
      nearbyPagingController.error = e;
    }
  }

  Future<void> fetchRecentFeeds(int pageKey) async {
    try {
      final newPage = await FeedServices.getRecentFeeds(
        limit: pageKey,
        lat: currentUser.value.location!.latitude!,
        long: currentUser.value.location!.longitude!,
      );

      final newItems = newPage;
      final hasNextPage = newPage.isEmpty;

      if (!hasNextPage) {
        recentPagingController.appendLastPage(newItems);
      } else if (hasNextPage) {
        recentPagingController.appendPage(newItems, pageKey + 1);
      }
    } catch (e) {
      logError(e.toString());
      recentPagingController.error = e;
    }
  }

  @override
  void onClose() {
    nearbyPagingController.dispose();
    recentPagingController.dispose();
    super.onClose();
  }
}
