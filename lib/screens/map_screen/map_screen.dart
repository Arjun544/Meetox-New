import 'dart:io';

import 'package:meetox/controllers/map_controller.dart';
import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/models/circle_model.dart';
import 'package:meetox/models/user_model.dart';
import 'package:meetox/services/circle_services.dart';
import 'package:meetox/services/follow_services.dart';
import 'package:meetox/services/user_services.dart';
import 'package:meetox/widgets/top_bar.dart';

import 'components/circles_cluster_layer.dart';
import 'components/current_user_layer.dart';
import 'components/custom_tile_layer.dart';
import 'components/followers_cluster_layer.dart';
import 'components/main_filters.dart';
import 'components/users_cluster_layer.dart';

class MapScreen extends HookWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MapScreenController())
      ..mapController = MapController();

    final usersResult = useQuery<List<UserModel>, dynamic>(
      CacheKeys.nearByUsers,
      () async => await UserServices.getNearByUsers(
        lat: currentUser.value.location!.latitude!,
        long: currentUser.value.location!.longitude!,
        distanceInKm: currentUser.value.isPremium! ? 600 : 300,
      ),
      refreshConfig: const RefreshConfig(
        staleDuration: Duration(minutes: 5),
        refreshInterval: Duration(minutes: 5),
        refreshOnMount: false,
        refreshOnQueryFnChange: false,
        refreshOnNetworkStateChange: true,
      ),
      onData: (value) {},
      onError: (error) {
        logError(error.toString());
      },
    );

    final circlesResult = useQuery<List<CircleModel>, dynamic>(
      CacheKeys.nearByCircles,
      () async => await CircleServices.getNearByCircles(
        lat: currentUser.value.location!.latitude!,
        long: currentUser.value.location!.longitude!,
        distanceInKm: currentUser.value.isPremium! ? 600 : 300,
      ),
      refreshConfig: const RefreshConfig(
        staleDuration: Duration(minutes: 5),
        refreshInterval: Duration(minutes: 5),
        refreshOnMount: false,
        refreshOnQueryFnChange: false,
        refreshOnNetworkStateChange: true,
      ),
      onData: (value) {},
      onError: (error) {
        logError(error.toString());
      },
    );

    // final questionsResult = useQuery(
    //   QueryOptions(
    //     document: gql(getNearbyQuestions),
    //     pollInterval: const Duration(minutes: 5),
    //     variables: {
    //       'latitude': currentUser.value.location!.coordinates![0],
    //       'longitude': currentUser.value.location!.coordinates![1],
    //       'distanceInKM': currentUser.value.isPremium! ? 600 : 300,
    //     },
    //   ),
    // );

    final followersResult = useQuery<List<UserModel>, dynamic>(
      CacheKeys.nearByFollowers,
      () async => await FollowServices.getNearByFollowersFollowings(
        lat: currentUser.value.location!.latitude!,
        long: currentUser.value.location!.longitude!,
        distanceInKm: currentUser.value.isPremium! ? 600 : 300,
      ),
      refreshConfig: const RefreshConfig(
        staleDuration: Duration(minutes: 5),
        refreshInterval: Duration(minutes: 5),
        refreshOnMount: false,
        refreshOnQueryFnChange: false,
        refreshOnNetworkStateChange: true,
      ),
      onData: (value) {},
      onError: (error) {
        logError(error.toString());
      },
    );

    return Scaffold(
      body: Stack(
        children: [
          Obx(
            () => FlutterMap(
              mapController: controller.mapController,
              options: MapOptions(
                center: LatLng(
                  controller.rootController.currentPosition.value.latitude,
                  controller.rootController.currentPosition.value.longitude,
                ),
                zoom: 16,
                minZoom: 1,
                maxZoom: 16,
                keepAlive: true,
                interactiveFlags:
                    InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                onMapReady: () {
                  controller.animatedMapMove(
                    LatLng(
                      controller.rootController.currentPosition.value.latitude,
                      controller.rootController.currentPosition.value.longitude,
                    ),
                    14,
                  );
                },
                maxBounds: controller.rootController.mapBounds.value,
                boundsOptions: const FitBoundsOptions(inside: true),
                onMapEvent: (event) {
                  if (event.source.name == 'onDrag' &&
                      controller.isDraggingMap.value == false) {
                    controller.isDraggingMap.value = true;
                  } else if (event.source.name == 'dragEnd' &&
                      controller.isDraggingMap.value == true) {
                    controller.isDraggingMap.value = false;
                  }
                },
              ),
              children:
                  // children: circlesResult.result.isNotLoading ||
                  //         questionsResult.result.isNotLoading ||
                  //         followersResult.result.isNotLoading ||
                  !usersResult.isLoading ||
                          !followersResult.isLoading ||
                          !circlesResult.isLoading
                      ? controller.currentMainFilter.value == 'All'
                          ? [
                              const CustomTileLayer(),
                              const CurrentUserLayer(),
                              if (circlesResult.data != null)
                                CirclesClusterlayer(
                                  circlesResult.data!,
                                ),
                              if (usersResult.data != null)
                                UsersClusterlayer(
                                  usersResult.data!,
                                ),
                              // if (questionsResult.result.data != null)
                              //   QuestionsClusterlayer(
                              //     questionsResult
                              //         .result.data!['getNearByQuestions']
                              //         .map<Question>(
                              //           (question) => Question.fromRawJson(
                              //               json.encode(question)),
                              //         )
                              //         .toList() as List<Question>,
                              //   ),
                              if (followersResult.data != null)
                                FollowersClusterlayer(
                                  followersResult.data!,
                                ),
                            ]
                          : controller.currentMainFilter.value == 'Circles'
                              ? [
                                  const CustomTileLayer(),
                                  const CurrentUserLayer(),
                                  CirclesClusterlayer(
                                    circlesResult.data!,
                                  ),
                                ]
                              : controller.currentMainFilter.value ==
                                      'Questions'
                                  ? [
                                      const CustomTileLayer(),
                                      const CurrentUserLayer(),
                                      // QuestionsClusterlayer(
                                      //   questionsResult
                                      //       .result.data!['getNearByQuestions']
                                      //       .map<Question>(
                                      //         (question) =>
                                      //             Question.fromRawJson(
                                      //                 json.encode(question)),
                                      //       )
                                      //       .toList() as List<Question>,
                                      // ),
                                    ]
                                  : controller.currentMainFilter.value ==
                                          'Followers/Followings'
                                      ? [
                                          const CustomTileLayer(),
                                          const CurrentUserLayer(),
                                          FollowersClusterlayer(
                                            followersResult.data!,
                                          )
                                        ]
                                      : [
                                          const CustomTileLayer(),
                                          const CurrentUserLayer(),
                                          UsersClusterlayer(
                                            usersResult.data!,
                                          ),
                                        ]
                      : [],
            ),
          ),
          Obx(
            () => !controller.isDraggingMap.value
                ? SlideInDown(
                    child: TopBar(
                      isMapScreen: true,
                      isPrecise: controller.isLocationPrecise,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          Obx(
            () => controller.isCurrentFilterMarkVisible.value
                ? Positioned(
                    left: 15.sp,
                    top: 120.sp,
                    child: SlideInLeft(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: context.theme.cardColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          child: Text(
                            controller.currentMainFilter.value,
                            style: context.theme.textTheme.labelSmall,
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          Obx(
            () => !controller.isDraggingMap.value
                ? Positioned(
                    right: 0,
                    top: 150.sp,
                    child: SlideInRight(
                      child: const MainFilters(),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          Positioned(
            left: 15,
            bottom: 115.sp,
            child:
                // circlesResult.result.isLoading ||
                //         circlesResult.result.data == null ||
                usersResult.isLoading ||
                        followersResult.isLoading ||
                        circlesResult.isLoading
                    // questionsResult.result.isLoading ||
                    // questionsResult.result.data == null
                    ? Container(
                        height: 50.sp,
                        width: 50.sp,
                        padding: EdgeInsets.symmetric(horizontal: 15.sp),
                        decoration: BoxDecoration(
                          color: AppColors.primaryYellow.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: LoadingAnimationWidget.staggeredDotsWave(
                          color: AppColors.customBlack,
                          size: 20.sp,
                        ),
                      )
                    : const SizedBox.shrink(),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: Platform.isIOS ? 100.sp : 80.sp),
        child: Obx(
          () => !controller.isDraggingMap.value
              ? SlideInRight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FloatingActionButton(
                        elevation: 0,
                        backgroundColor: context
                            .theme.floatingActionButtonTheme.backgroundColor,
                        child: Icon(
                          IconsaxBold.textalign_center,
                          color: context.theme.appBarTheme.iconTheme!.color,
                        ),
                        // TODO: Show Markers List Sheet
                        onPressed: () {},
                        // onPressed: () => showCustomSheet(
                        //   context: context,
                        //   child: MarkersListSheet(
                        //     usersResult,
                        //     circlesResult,
                        //     followersResult,
                        //     questionsResult,
                        //   ),
                        // ),
                      ),
                      const SizedBox(height: 14),
                      FloatingActionButton(
                        elevation: 0,
                        backgroundColor: context
                            .theme.floatingActionButtonTheme.backgroundColor,
                        child: Icon(
                          FlutterRemix.focus_fill,
                          color: context.theme.appBarTheme.iconTheme!.color,
                        ),
                        onPressed: () async {
                          // final double distance = Geolocator.distanceBetween(
                          //   controller.rootController.currentPosition.value.latitude - 1,
                          //   controller.rootController.currentPosition.value.longitude - 1,
                          //   controller.rootController.currentPosition.value.latitude + 1,
                          //   controller.rootController.currentPosition.value.longitude + 1,
                          // );
                          // log('distance: ${(distance * 0.001).toStringAsFixed(0)}');
                          controller.animatedMapMove(
                            LatLng(
                              controller.rootController.currentPosition.value
                                  .latitude,
                              controller.rootController.currentPosition.value
                                  .longitude,
                            ),
                            15,
                          );
                          // int tiles = FMTC.instance('Map store').stats.storeLength;

                          // final int checkTiles = FMTC.instance('Map light').stats.storeLength;
                          // final bool isCachaed = FMTC
                          //     .instance('Map light')
                          //     .getTileProvider(
                          //       FMTCTileProviderSettings(behavior: CacheBehavior.cacheFirst),
                          //     )
                          //     .checkTileCached(
                          //       coords: Coords(
                          //           controller.rootController.currentPosition.value.latitude,
                          //           controller
                          //               .rootController.currentPosition.value.longitude),
                          //       options: TileLayer(
                          //         tileProvider: FMTC.instance('Map light').getTileProvider(
                          //               FMTCTileProviderSettings(
                          //                   behavior: CacheBehavior.cacheFirst),
                          //             ),
                          //         minZoom: 1,
                          //         maxZoom: 14,
                          //         tileBounds: controller.rootController.mapBounds.value,
                          //         urlTemplate: lightMapUrl,
                          //       ),
                          //       customURL: lightMapUrl,
                          //     );
                          // log('tiles: ');
                        },
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }
}
