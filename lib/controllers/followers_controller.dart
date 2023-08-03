import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/models/user_model.dart';
import 'package:meetox/services/follow_services.dart';

class FollowersController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final String id;
  final bool isFollowing;
  FollowersController(this.id, this.isFollowing);

  late TabController tabController;

  final followersPagingController =
      PagingController<int, UserModel>(firstPageKey: 1);
  final followingPagingController =
      PagingController<int, UserModel>(firstPageKey: 1);

  final RxString followersSearchQuery = ''.obs;
  final RxString followingSearchQuery = ''.obs;
  late Worker followersSearchDebounce;
  late Worker followingSearchDebounce;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(
        initialIndex: isFollowing ? 1 : 0, length: 2, vsync: this);
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
        id: id,
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
        id: id,
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

  // void onDeleteCompleted(
  //     Map<String, dynamic>? resultData, BuildContext context) {
  //   if (resultData != null) {
  //     final circle_model.Circle newCircle = circle_model.Circle.fromJson(
  //         resultData['deleteCircle'] as Map<String, dynamic>);

  //     followersPagingController.itemList!.remove(newCircle);
  //     followersPagingController.refresh();
  //     Navigator.pop(context);
  //   }
  // }

  @override
  void onClose() {
    followersPagingController.dispose();
    followersSearchDebounce.dispose();
    followingPagingController.dispose();
    followingSearchDebounce.dispose();
    tabController.dispose();
    super.onClose();
  }
}
