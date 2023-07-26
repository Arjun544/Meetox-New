import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/screens/splash_screen.dart';

import '../screens/auth_screens/auth_screen.dart';

class GlobalController extends GetxController {
  @override
  void onInit() {
    // setupAuthListener();
    super.onInit();
  }

  void setupAuthListener() {
    supabase.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      if (event == AuthChangeEvent.signedIn) {
        Get.offAll(() => const SplashScreen());
      } else if (event == AuthChangeEvent.signedOut) {
        Get.offAll(() => const AuthScreen());
      }
    });
  }

  final List<String> userAvatars = [
    AssetsManager.avatar1,
    AssetsManager.avatar2,
    AssetsManager.avatar3,
    AssetsManager.avatar4,
    AssetsManager.avatar5,
    AssetsManager.avatar6,
    AssetsManager.avatar7,
    AssetsManager.avatar8,
    AssetsManager.avatar9,
  ];

  final List<String> circleAvatars = [
    AssetsManager.circle1,
    AssetsManager.circle2,
    AssetsManager.circle3,
    AssetsManager.circle4,
    AssetsManager.circle5,
    AssetsManager.circle6,
    AssetsManager.circle7,
  ];
}
