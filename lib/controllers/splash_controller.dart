import 'package:meetox/models/user_model.dart';
import 'package:meetox/screens/add_profile_screen/add_profile_screen.dart';
import 'package:meetox/screens/auth_screens/auth_screen.dart';
import 'package:meetox/screens/on_boarding_screen/on_boarding_screen.dart';
import 'package:meetox/screens/root_screen.dart';
import 'package:meetox/services/user_services.dart';

import '../core/imports/core_imports.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    getUser();
    super.onInit();
  }

  @override
  void onReady() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [],
    );
    super.onReady();
  }

  void getUser() async {
    try {
      final UserModel user = await UserServices.userById();
      if (user.name == null) {
        Get.offAll(() => const AddProfileScreen());
      } else {
        currentUser(user);
        Get.offAll(() => const RootScreen());
      }
    } catch (e) {
      logError(e.toString());
      Get.offAll(() => const OnBoardingScreen());
    }
  }

  @override
  void onClose() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
  }
}
