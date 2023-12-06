import 'dart:developer';

import 'package:geolocator/geolocator.dart';
import 'package:meetox/controllers/map_controller.dart';
import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/models/user_model.dart';
import 'package:meetox/screens/map_screen/map_screen.dart';
import 'package:meetox/services/user_services.dart';

import '../core/imports/core_imports.dart';
import '../helpers/has_location_permission.dart';
import '../screens/conversation_screen/conversation_screen.dart';
import '../screens/feeds_screen/feeds_screen.dart';
import '../screens/notification_screen/notification_screen.dart';

class RootController extends GetxController {
  final ZoomDrawerController zoomDrawerController = ZoomDrawerController();

  final selectedTab = 1.obs;

  final List<Widget> items = [
    const MapScreen(),
    const FeedScreen(),
    const SizedBox.shrink(),
    const ConversationScreen(),
    const NotificationScreen(),
  ];

  final RxBool isLocationPrecise = false.obs;
  Rx<LatLngBounds> mapBounds = LatLngBounds(LatLng(0, 0), LatLng(0, 0)).obs;
  Rx<LocationPermission> locationPermission = LocationPermission.denied.obs;
  final RxString currentMapStyle = 'default'.obs;

  RxString currentAddress = ''.obs;
  Rx<Position> currentPosition = Position(
    latitude: 0,
    accuracy: 0,
    altitude: 0,
    longitude: 0,
    speed: 0,
    heading: 0,
    speedAccuracy: 0,
    altitudeAccuracy: 0.0,
    headingAccuracy: 0.0,
    timestamp: DateTime.now(),
  ).obs;

  @override
  Future<void> onInit() async {
    await getLocation();
    currentMapStyle.value = getStorage.read('currentMapStyle') ?? 'default';
    super.onInit();
  }

  Future<bool> getLocationPermissions() async => hasLocationPermission();

  Future<void> getLocation() async {
    final hasPermission = await getLocationPermissions();

    logSuccess('hasPermission: $hasPermission');
    if (hasPermission) {
      // ignore: omit_local_variable_types
      final bool isPrecise = getStorage.read('isPrecise') ?? false;

      final newPostion = await Geolocator.getCurrentPosition(
        desiredAccuracy:
            isPrecise ? LocationAccuracy.best : LocationAccuracy.lowest,
      );

      // If current location & address are available, update in db
      if (newPostion.toString().isNotEmpty) {
        log('With location');

        currentPosition.value = newPostion;

        final placemarks = await placemarkFromCoordinates(
          currentPosition.value.latitude,
          currentPosition.value.longitude,
        );

        final address =
            '${placemarks[0].administrativeArea}, ${placemarks[0].isoCountryCode}';

        log('Updated Address');
        currentUser.value.location = LocationModel(
          longitude: currentPosition.value.longitude,
          latitude: currentPosition.value.latitude,
        );

        currentUser.refresh();

        await UserServices.updateLocation(
          address: address,
          long: currentPosition.value.longitude,
          lat: currentPosition.value.latitude,
        );

        mapBounds.value = !currentUser.value.isPremium!
            // Approx 300 kms
            ? LatLngBounds(
                LatLng(
                  currentPosition.value.latitude - 1.1,
                  currentPosition.value.longitude - 1.1,
                ),
                LatLng(
                  currentPosition.value.latitude + 1.1,
                  currentPosition.value.longitude + 1.1,
                ),
              )
            : LatLngBounds(
                // Approx 600 kms
                LatLng(
                  currentPosition.value.latitude - 2.1,
                  currentPosition.value.longitude - 2.1,
                ),
                LatLng(
                  currentPosition.value.latitude + 2.1,
                  currentPosition.value.longitude + 2.1,
                ),
              );
      }
    } else {
      log('Without location ${currentUser.value.location}');
      currentPosition.value = Position(
        latitude: currentUser.value.location!.latitude!,
        longitude: currentUser.value.location!.longitude!,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        altitudeAccuracy: 0.0,
        headingAccuracy: 0.0,
        speedAccuracy: 0,
      );
      mapBounds.value = !currentUser.value.isPremium!
          // Approx 300 kms
          ? LatLngBounds(
              LatLng(
                currentPosition.value.latitude - 1.1,
                currentPosition.value.longitude - 1.1,
              ),
              LatLng(
                currentPosition.value.latitude + 1.1,
                currentPosition.value.longitude + 1.1,
              ),
            )
          : LatLngBounds(
              // Approx 600 kms
              LatLng(
                currentPosition.value.latitude - 2.1,
                currentPosition.value.longitude - 2.1,
              ),
              LatLng(
                currentPosition.value.latitude + 2.1,
                currentPosition.value.longitude + 2.1,
              ),
            );

      final mapScreenController = Get.put(MapScreenController());
      // ignore: cascade_invocations
      mapScreenController.animatedMapMove(
        LatLng(
          currentUser.value.location!.latitude!,
          currentUser.value.location!.longitude!,
        ),
        15,
      );
    }
  }
}
