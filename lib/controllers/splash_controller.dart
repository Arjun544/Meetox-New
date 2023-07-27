import '../core/imports/core_imports.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [],
    );
    super.onReady();
  }

  @override
  void onClose() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
  }
}
