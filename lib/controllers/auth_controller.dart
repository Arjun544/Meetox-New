import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/models/user_model.dart';
import 'package:meetox/screens/add_profile_screen/add_profile_screen.dart';
import 'package:meetox/services/auth_services.dart';
import 'package:meetox/services/user_services.dart';

import '../core/imports/core_imports.dart';
import '../screens/root_screen.dart';

class AuthController extends GetxController {
  final isLoading = false.obs;

  void handleLogin() async {
    final AuthResponse response = await AuthServices.signInWithGoogle(
      isLoading,
    );

    if (response.user != null) {
      final UserModel user = await UserServices.userById();
      currentUser(user);
      if (currentUser.value.name == null) {
        Get.offAll(() => const AddProfileScreen());
      } else {
        Get.offAll(() => const RootScreen());
      }
      isLoading(false);
    }
  }
}
