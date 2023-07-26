import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';

class AuthController extends GetxController {
  final isLoading = false.obs;

  @override
  void onInit() {
    setupAuthListener();
    super.onInit();
  }

  void setupAuthListener() {
    supabase.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      logSuccess(data.session.toString());
      if (event == AuthChangeEvent.signedIn) {}
    });
  }
}
