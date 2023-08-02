import 'package:meetox/controllers/map_controller.dart';
import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/screens/map_screen/components/current_user_marker.dart';

class CurrentUserLayer extends GetView<MapScreenController> {
  const CurrentUserLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return MarkerLayer(
      markers: [
        Marker(
          point: LatLng(
            controller.rootController.currentPosition.value.latitude,
            controller.rootController.currentPosition.value.longitude,
          ),
          width: 60.sp,
          height: 60.sp,
          builder: (context) => const CurrentUserMarker(),
        ),
      ],
    );
  }
}
