import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/models/user_model.dart';
import 'package:meetox/services/follow_services.dart';
import 'package:meetox/services/user_services.dart';

class UserProfileController extends GetxController
    with GetTickerProviderStateMixin {
  late TabController tabController;
  final RxString userId = ''.obs;

  final RxBool isSocialsLoading = false.obs;
  final RxInt followerCount = 0.obs;
  final RxInt followingCount = 0.obs;
  final RxList<Social> socials = <Social>[].obs;

  @override
  void onInit() {
    tabController = TabController(length: 2, vsync: this);
    super.onInit();
  }

  @override
  void onReady() {
    getFollowersCount();
    getFollowingsCount();
    getSocials();
    super.onReady();
  }

  void getFollowersCount() async {
    await FollowServices.getFollowersCount(
      id: userId.value,
      onSuccess: (followers) => followerCount.value = followers,
    );
  }

  void getFollowingsCount() async {
    await FollowServices.getFollowingsCount(
      id: userId.value,
      onSuccess: (followings) => followingCount.value = followings,
    );
  }

  void getSocials() async {
    socials.value = await UserServices.getSocials(
      isLoading: isSocialsLoading,
      id: userId.value,
    );
  }
}
