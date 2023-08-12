import 'package:meetox/controllers/map_controller.dart';
import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/widgets/custom_tabbar.dart';
import 'package:meetox/widgets/mini_map.dart';

class CustomMapOptions extends GetView<MapScreenController> {
  const CustomMapOptions({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> handleMapStyleChange(int value) async {
      if (value == 0) {
        controller.rootController.currentMapStyle.value = 'default';
        await getStorage.write('currentMapStyle', 'default');
      } else if (value == 1) {
        controller.rootController.currentMapStyle.value = 'sky';
        await getStorage.write('currentMapStyle', 'sky');
      } else {
        controller.rootController.currentMapStyle.value = 'meetox';
        await getStorage.write('currentMapStyle', 'meetox');
      }
    }

    return Container(
      height: Get.height * 0.45,
      width: Get.width,
      padding: EdgeInsets.symmetric(horizontal: 20.sp),
      decoration: BoxDecoration(
        color: context.theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Center(
            child: Container(
              height: 5.sp,
              width: 70.sp,
              decoration: BoxDecoration(
                color: context.theme.bottomNavigationBarTheme.backgroundColor,
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          Text(
            'Map styles',
            style: context.theme.textTheme.labelSmall,
          ),
          // SizedBox(height: 10.sp),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              height: 200.sp,
              width: Get.width,
              child: MiniMap(
                latitude: currentUser.value.location!.latitude!,
                longitude: currentUser.value.location!.longitude!,
                image: currentUser.value.photo!,
                color: AppColors.primaryYellow,
              ),
            ),
          ),
          CustomTabbar(
            controller: controller.stylesTabController,
            onTap: handleMapStyleChange,
            tabs: const [
              Tab(
                text: 'Default',
              ),
              Tab(
                text: 'Sky',
              ),
              Tab(
                text: 'Meetox',
              ),
            ],
          ),
          SizedBox(height: 20.sp),
        ],
      ),
    );
  }
}
