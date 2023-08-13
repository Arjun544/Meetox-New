import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/models/user_model.dart';
import 'package:meetox/services/follow_services.dart';

class MyFollowersController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;

  final RxInt currentIndex = 0.obs;

  final followersPagingController =
      PagingController<int, UserModel>(firstPageKey: 1);
  final followingPagingController =
      PagingController<int, UserModel>(firstPageKey: 1);

  final RxString followersSearchQuery = ''.obs;
  final RxString followingSearchQuery = ''.obs;
  Worker? followersSearchDebounce;
  Worker? followingSearchDebounce;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(
        initialIndex: currentIndex.value, length: 2, vsync: this);
    followersPagingController.addPageRequestListener((page) async {
      await fetchFollowers(page);
      followersSearchDebounce = debounce(
        followersSearchQuery,
        (value) {
          followersPagingController.refresh();
        },
        time: const Duration(seconds: 2),
      );
    });
    followingPagingController.addPageRequestListener((page) async {
      await fetchFollowing(page);
      followingSearchDebounce = debounce(
        followingSearchQuery,
        (value) {
          followingPagingController.refresh();
        },
        time: const Duration(seconds: 2),
      );
    });
  }

  Future<void> fetchFollowers(int pageKey) async {
    try {
      final newPage = await FollowServices.getFollowers(
        id: currentUser.value.id!,
        limit: pageKey,
        query: followersSearchQuery.value.isEmpty
            ? null
            : followersSearchQuery.value,
      );

      final newItems = newPage;
      final hasNextPage = newPage.isEmpty;

      if (!hasNextPage) {
        followersPagingController.appendLastPage(newItems);
      } else if (hasNextPage) {
        followersPagingController.appendPage(newItems, pageKey + 1);
      }
    } catch (e) {
      logError(e.toString());
      followersPagingController.error = e;
    }
  }

  Future<void> fetchFollowing(int pageKey) async {
    try {
      final newPage = await FollowServices.getFollowings(
        id: currentUser.value.id!,
        limit: pageKey,
        query: followersSearchQuery.value.isEmpty
            ? null
            : followersSearchQuery.value,
      );

      final newItems = newPage;
      final hasNextPage = newPage.isEmpty;

      if (!hasNextPage) {
        followingPagingController.appendLastPage(newItems);
      } else if (hasNextPage) {
        followingPagingController.appendPage(newItems, pageKey + 1);
      }
    } catch (e) {
      logError(e.toString());
      followingPagingController.error = e;
    }
  }
}
