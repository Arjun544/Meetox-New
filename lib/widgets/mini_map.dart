import 'package:cached_network_image/cached_network_image.dart';
import 'package:meetox/controllers/map_controller.dart';
import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/helpers/get_distance.dart';

import 'user_initials.dart';

class MiniMap extends GetView<MapScreenController> {
  final double latitude;
  final double longitude;
  final String image;
  final Color color;

  const MiniMap({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.image,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    Get.put(MapScreenController());

    final currentLatitude =
        controller.rootController.currentPosition.value.latitude;
    final currentLongitude =
        controller.rootController.currentPosition.value.longitude;

    final distanceBtw = getDistance(
      currentLatitude,
      currentLongitude,
      latitude,
      longitude,
    );
    return Stack(
      children: [
        Obx(
          () => FlutterMap(
            options: MapOptions(
              center: LatLng(
                latitude,
                longitude,
              ),
              zoom: 12,
              minZoom: 1,
              maxZoom: 12,
              keepAlive: true,
              interactiveFlags: InteractiveFlag.none,
              onMapReady: () {},
            ),
            children: [
              if (controller.currentMapStyle.value == 'default')
                context.isDarkMode
                    ? TileLayer(
                        tileProvider:
                            FMTC.instance('Map dark').getTileProvider(),
                        minZoom: 1,
                        maxZoom: 12,
                        urlTemplate: darkMapUrl,
                        userAgentPackageName: 'Monochrome dark',
                        additionalOptions: {
                          'access_token': mapBoxAccessToken,
                        },
                      )
                    : TileLayer(
                        tileProvider:
                            FMTC.instance('Map light').getTileProvider(
                                  FMTCTileProviderSettings(),
                                ),
                        minZoom: 1,
                        maxZoom: 12,
                        urlTemplate: lightMapUrl,
                        userAgentPackageName: 'Monochrome light',
                        additionalOptions: {
                          'access_token': mapBoxAccessToken,
                        },
                      )
              else
                controller.currentMapStyle.value == 'sky'
                    ? TileLayer(
                        tileProvider: FMTC.instance('Map sky').getTileProvider(
                              FMTCTileProviderSettings(),
                            ),
                        minZoom: 1,
                        maxZoom: 12,
                        urlTemplate: skyMapUrl,
                        userAgentPackageName: 'Monochrome sky',
                        additionalOptions: {
                          'access_token': mapBoxAccessToken,
                        },
                      )
                    : TileLayer(
                        tileProvider:
                            FMTC.instance('Map meetox').getTileProvider(
                                  FMTCTileProviderSettings(),
                                ),
                        minZoom: 1,
                        maxZoom: 12,
                        urlTemplate: meetoxMapUrl,
                        userAgentPackageName: 'Monochrome meetox',
                        additionalOptions: {
                          'access_token': mapBoxAccessToken,
                        },
                      ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(
                      controller.rootController.currentPosition.value.latitude,
                      controller.rootController.currentPosition.value.longitude,
                    ),
                    width: 60.sp,
                    height: 60.sp,
                    builder: (context) => Pulse(
                      infinite: true,
                      // ignore: avoid_bool_literals_in_conditional_expressions
                      animate: false,
                      child: Container(
                        width: 70.sp,
                        height: 70.sp,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Dance(
                          duration: const Duration(milliseconds: 2000),
                          infinite: true,
                          child: Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.bottomCenter,
                            children: [
                              image.isEmpty
                                  ? const UserInititals(name: 'A')
                                  : Container(
                                      width: 40.h,
                                      height: 40.w,
                                      clipBehavior: Clip.hardEdge,
                                      decoration: BoxDecoration(
                                        color: AppColors.customGrey,
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                          width: 3,
                                          color: color,
                                        ),
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: CachedNetworkImageProvider(
                                            image,
                                          ),
                                        ),
                                      ),
                                    ),
                              Positioned(
                                bottom: -18,
                                child: Icon(
                                  FlutterRemix.arrow_down_s_fill,
                                  size: 30.sp,
                                  color: color,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8),
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: context.theme.scaffoldBackgroundColor.withOpacity(0.7),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                FlutterRemix.pin_distance_fill,
                size: 18,
                color: context.theme.iconTheme.color,
              ),
              const SizedBox(width: 10),
              Text(
                '~ ${distanceBtw.toStringAsFixed(0)} KMs',
                style: context.theme.textTheme.labelSmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
