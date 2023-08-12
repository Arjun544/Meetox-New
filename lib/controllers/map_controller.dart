import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/helpers/has_location_permission.dart';
import 'package:meetox/models/circle_model.dart';
import 'package:meetox/models/user_model.dart';
import 'package:meetox/services/circle_services.dart';
import 'package:meetox/services/follow_services.dart';
import 'package:meetox/services/user_services.dart';

import '../core/imports/core_imports.dart';
import 'root_controller.dart';

class MapScreenController extends GetxController
    with GetTickerProviderStateMixin {
  final RootController rootController = Get.find();
  MapController? mapController;
  late TabController stylesTabController;
  final RxString currentMapStyle = 'default'.obs;

  final RxList<UserModel> nearbyUsers = <UserModel>[].obs;
  final RxList<UserModel> nearbyFollowers = <UserModel>[].obs;
  final RxList<CircleModel> nearbyCircles = <CircleModel>[].obs;

  final RxBool isLoading = false.obs;
  final RxBool hasAppliedFilters = false.obs;
  final RxBool isLocationPrecise = false.obs;
  final RxString currentMainFilter = 'All'.obs;
  final RxBool isCurrentFilterMarkVisible = false.obs;
  final RxBool isDraggingMap = false.obs;
  final RxBool isFiltersVisible = true.obs;

  // Filters
  final RxInt markersFilter = 0.obs;
  final RxDouble radius = (currentUser.value.isPremium! ? 600.0 : 300.0).obs;
  // final RxList<circle_model.Circle> oldCircles = <circle_model.Circle>[].obs;
  // final RxList<QuestionModel> oldQuestions = <QuestionModel>[].obs;
  // final RxList<UserModel> oldUsers = <UserModel>[].obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await hasLocationPermission();
    isLocationPrecise.value = getStorage.read('isPrecise') ?? false;
    stylesTabController = TabController(
        initialIndex: currentMapStyle.value == 'default'
            ? 0
            : currentMapStyle.value == 'sky'
                ? 1
                : 2,
        length: 3,
        vsync: this);
    currentMapStyle.value = getStorage.read('currentMapStyle') ?? 'default';
  }

  @override
  void onReady() {
    getNearbyData();
    super.onReady();
  }

  void animatedMapMove(LatLng destLocation, double destZoom) {
    final latTween = Tween<double>(
      begin: mapController!.center.latitude,
      end: destLocation.latitude,
    );
    final lngTween = Tween<double>(
      begin: mapController!.center.longitude,
      end: destLocation.longitude,
    );
    final zoomTween = Tween<double>(begin: mapController!.zoom, end: destZoom);

    final controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    final Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      mapController!.move(
        LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
        zoomTween.evaluate(animation),
      );
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });
    controller.forward();
  }

  void getNearbyData() async {
    isLoading(true);
    final results = await Future.wait(
      [
        UserServices.getNearByUsers(
          lat: currentUser.value.location!.latitude!,
          long: currentUser.value.location!.longitude!,
          distanceInKm: currentUser.value.isPremium! ? 600 : 300,
        ),
        FollowServices.getNearByFollowersFollowings(
          lat: currentUser.value.location!.latitude!,
          long: currentUser.value.location!.longitude!,
          distanceInKm: currentUser.value.isPremium! ? 600 : 300,
        ),
        CircleServices.getNearByCircles(
          lat: currentUser.value.location!.latitude!,
          long: currentUser.value.location!.longitude!,
          distanceInKm: currentUser.value.isPremium! ? 600 : 300,
        ),
      ],
      cleanUp: (successValue) => isLoading(false),
    );
    isLoading(false);

    nearbyUsers(results[0] as List<UserModel>);
    nearbyFollowers(results[1] as List<UserModel>);
    nearbyCircles(results[2] as List<CircleModel>);
  }

  @override
  void dispose() {
    stylesTabController.dispose();
    mapController?.dispose();
    super.dispose();
  }
}
