import 'dart:developer';

import 'package:meetox/controllers/root_controller.dart';
import 'package:meetox/controllers/user_controller.dart';
import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/widgets/lazyload_stack.dart';

import '../widgets/custom_drawer.dart';
import '../widgets/navigation_bar.dart';

class RootScreen extends GetView<RootController> {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(RootController());

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ZoomDrawer(
        controller: controller.zoomDrawerController,
        menuScreen: const CustomDrawer(),
        mainScreen: const SubRootScreen(),
        borderRadius: 24,
        showShadow: true,
        angle: 0,
        mainScreenScale: 0.2,
        slideWidth: Get.width * 0.8,
        mainScreenTapClose: true,
        drawerShadowsBackgroundColor:
            context.theme.bottomSheetTheme.backgroundColor!,
        menuBackgroundColor: AppColors.primaryYellow,
      ),
    );
  }
}

class SubRootScreen extends HookWidget {
  const SubRootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(UserController(), permanent: true);

    SystemChrome.setSystemUIOverlayStyle(
      context.theme.appBarTheme.systemOverlayStyle!,
    );

    final controller = Get.put(RootController());

    final appLifecycleState = useAppLifecycleState();

    Future<void> appResumedOperations() async {
      if (await Permission.location.serviceStatus.isEnabled &&
          await Permission.location.status == PermissionStatus.granted) {
        await controller.getLocation();
      }
    }

    void appInactiveOperations() {}

    useEffect(
      () {
        if (appLifecycleState == AppLifecycleState.resumed) {
          log('app resumed');
          appResumedOperations();
        } else if (appLifecycleState == AppLifecycleState.inactive) {
          appInactiveOperations();
        }
        return () {};
      },
      [appLifecycleState],
    );

    return Scaffold(
      extendBody: true,
      body: Obx(
        () => LazyLoadIndexedStack(
          index: controller.selectedTab.value,
          children: controller.items,
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}
