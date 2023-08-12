import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/models/profile_model.dart';
import 'package:meetox/models/user_model.dart';
import 'package:meetox/services/user_services.dart';

class UserProfileController extends GetxController
    with GetTickerProviderStateMixin {
  late TabController tabController;
  final Rx<UserModel> user = UserModel().obs;

  final Rx<ProfileModel> profile = ProfileModel().obs;

  @override
  void onInit() {
    tabController = TabController(length: 2, vsync: this);
    super.onInit();
  }

  @override
  void onReady() {
    getProfileDetails();
    super.onReady();
  }

  void getProfileDetails() async {
    profile.value = await UserServices.getUserProfile(
      id: user.value.id!,
    );
  }
}
