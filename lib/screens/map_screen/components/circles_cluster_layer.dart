import 'package:meetox/controllers/map_controller.dart';
import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/models/circle_model.dart';

import '../../../core/imports/core_imports.dart';
import 'circle_marker.dart';

class CirclesClusterlayer extends GetView<MapScreenController> {
  const CirclesClusterlayer(this.circles, {super.key});

  final List<CircleModel> circles;

  @override
  Widget build(BuildContext context) {
    return ZoomIn(
      child: MarkerClusterLayerWidget(
          options: MarkerClusterLayerOptions(
            maxClusterRadius: 120,
            spiderfySpiralDistanceMultiplier: 2,
            circleSpiralSwitchover: 1,
            zoomToBoundsOnClick: false,
            size: Size(50.sp, 50.sp),
            markers: circles
                .map(
                  (circle) => Marker(
                    point: LatLng(
                      circle.location!.latitude!,
                      circle.location!.longitude!,
                    ),
                    width: 60.sp,
                    height: 60.sp,
                    builder: (context) => CustomCircleMarker(
                      circle: circle,
                    ),
                  ),
                )
                .toList(),
            polygonOptions: const PolygonOptions(
                borderColor: Colors.lightBlue, borderStrokeWidth: 4),
            builder: (context, markers) {
              return Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.lightBlue.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  height: 40.sp,
                  width: 40.sp,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.lightBlue,
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
    );
  }
}
