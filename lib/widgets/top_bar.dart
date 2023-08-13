import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meetox/controllers/map_controller.dart';
import 'package:meetox/controllers/root_controller.dart';
import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/screens/my_profile_screen/my_profile_screen.dart';

import '../core/imports/core_imports.dart';
import '../screens/map_screen/components/map_options.dart';
import '../services/user_services.dart';
import 'custom_sheet.dart';
import 'user_initials.dart';

class TopBar extends GetView<MapScreenController> {
  const TopBar({
    required this.isPrecise,
    super.key,
    this.isMapScreen = false,
    this.topPadding = 50,
  });
  final bool isMapScreen;
  final RxBool isPrecise;
  final double topPadding;

  @override
  Widget build(BuildContext context) {
    final rootController = Get.find<RootController>();

    // ignore: avoid_positional_boolean_parameters
    Future<void> onPreciseChange(bool val) async {
      isPrecise.value = val;
      controller.rootController.currentPosition.value =
          await Geolocator.getCurrentPosition(
        desiredAccuracy: val ? LocationAccuracy.best : LocationAccuracy.lowest,
      );
      await getStorage.write('isPrecise', val);

      final placemarks = await placemarkFromCoordinates(
        controller.rootController.currentPosition.value.latitude,
        controller.rootController.currentPosition.value.longitude,
      );

      final address =
          '${placemarks[0].administrativeArea}, ${placemarks[0].isoCountryCode}';
      controller.rootController.currentAddress.value = address;

      await UserServices.updateLocation(
        address: address,
        lat: controller.rootController.currentPosition.value.latitude,
        long: controller.rootController.currentPosition.value.longitude,
      );

      // currentUser.value = userData.user;
      controller.animatedMapMove(
        LatLng(
          controller.rootController.currentPosition.value.latitude,
          controller.rootController.currentPosition.value.longitude,
        ),
        15,
      );
    }

    return Container(
      height: 55.sp,
      width: Get.width,
      // color: Colors.white,
      margin: EdgeInsets.only(
        top: Platform.isIOS ? topPadding.sp : 40.sp,
        right: 15.sp,
        left: 15.sp,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () async =>
                await rootController.zoomDrawerController.open!(),
            onDoubleTap: () => Get.to(() => const MyProfileScreen()),
            child: Obx(
              () => currentUser.value.photo == null
                  ? UserInititals(name: currentUser.value.name ?? 'Unknown')
                  : Container(
                      height: 45.sp,
                      width: 45.sp,
                      decoration: BoxDecoration(
                        color: context.theme.primaryColor,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: context.isDarkMode
                                ? Colors.black
                                : Colors.grey[400]!,
                            blurRadius: 0.3,
                          ),
                        ],
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(
                            currentUser.value.photo!,
                          ),
                        ),
                      ),
                    ),
            ),
          ),
          if (isMapScreen)
            Row(
              children: [
                Text('Precise', style: context.theme.textTheme.labelSmall),
                SizedBox(width: 10.sp),
                Transform.scale(
                  scale: 0.7,
                  child: Obx(
                    () => CupertinoSwitch(
                      value: isPrecise.value,
                      trackColor: Colors.black,
                      activeColor: AppColors.primaryYellow,
                      onChanged: onPreciseChange,
                    ),
                  ),
                ),
              ],
            )
          else
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Current location',
                  style: context.theme.textTheme.labelSmall,
                ),
                SizedBox(height: 5.sp),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      IconsaxBold.location,
                      size: 15.sp,
                    ),
                    SizedBox(width: 5.sp),
                    Obx(
                      () => Text(
                        currentUser.value.address == null ||
                                currentUser.value.address!.isEmpty
                            ? 'Unknown'
                            : currentUser.value.address!,
                        style: context.theme.textTheme.labelMedium,
                      ),
                    ),
                    SizedBox(width: 5.sp),
                  ],
                ),
              ],
            ),
          Row(
            children: [
              if (isMapScreen)
                InkWell(
                  onTap: () => showCustomSheet(
                    context: context,
                    child: const CustomMapOptions(),
                  ),
                  child: Container(
                    height: 40.sp,
                    width: 40.sp,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(right: 10.sp),
                    decoration: BoxDecoration(
                      color: context.theme.dividerColor,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: context.isDarkMode
                              ? Colors.black
                              : Colors.grey[400]!,
                          blurRadius: 0.3,
                        ),
                      ],
                    ),
                    child: const Icon(IconsaxBold.setting),
                  ),
                ),
              Container(
                height: 40.sp,
                width: 40.sp,
                decoration: BoxDecoration(
                  color: !isMapScreen
                      ? context.theme.indicatorColor
                      : context.isDarkMode
                          ? Colors.black
                          : Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color:
                          context.isDarkMode ? Colors.black : Colors.grey[400]!,
                      blurRadius: 0.3,
                    ),
                  ],
                ),
                child: const Icon(IconsaxBold.search_normal),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
