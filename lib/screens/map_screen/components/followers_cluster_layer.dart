import 'package:meetox/controllers/map_controller.dart';
import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/models/user_model.dart';
import 'package:meetox/screens/map_screen/components/follower_marker.dart';

class FollowersClusterlayer extends GetView<MapScreenController> {
  const FollowersClusterlayer(this.followers, {super.key});

  final List<UserModel> followers;

  @override
  Widget build(BuildContext context) {
    final tappedFollower = UserModel().obs;
    return ZoomIn(
      child: Obx(
        () => MarkerClusterLayerWidget(
          options: MarkerClusterLayerOptions(
            maxClusterRadius: 120,
            spiderfySpiralDistanceMultiplier: 2,
            circleSpiralSwitchover: 1,
            zoomToBoundsOnClick: false,
            size: Size(50.sp, 50.sp),
            markers: tappedFollower.value.id != null
                ? [
                    Marker(
                      point: LatLng(
                        tappedFollower.value.location!.latitude!,
                        tappedFollower.value.location!.longitude!,
                      ),
                      width: 60.sp,
                      height: 60.sp,
                      builder: (context) => FollowerMarker(
                        follower: tappedFollower.value,
                        tappedFollower: tappedFollower,
                      ),
                    )
                  ]
                : followers
                    .map(
                      (follower) => Marker(
                        point: LatLng(
                          follower.location!.latitude!,
                          follower.location!.longitude!,
                        ),
                        width: 60.sp,
                        height: 60.sp,
                        builder: (context) => FollowerMarker(
                          follower: follower,
                          tappedFollower: tappedFollower,
                        ),
                      ),
                    )
                    .toList(),
            polygonOptions: const PolygonOptions(
              borderColor: AppColors.primaryYellow,
              borderStrokeWidth: 4,
            ),
            popupOptions: PopupOptions(
              popupState: PopupState(),
              popupBuilder: (_, marker) => const SizedBox.shrink(),
            ),
            builder: (context, markers) {
              return Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primaryYellow.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  height: 40.sp,
                  width: 40.sp,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.primaryYellow,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    '+${markers.length - 1}',
                    style: context.theme.textTheme.labelMedium,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
