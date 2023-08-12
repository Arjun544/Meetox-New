import 'package:map_launcher/map_launcher.dart';
import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';

class NavigateButton extends StatelessWidget {
  final String title;
  final String address;
  final double latitude;
  final double longitude;
  const NavigateButton({
    super.key,
    required this.title,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await MapLauncher.showDirections(
          mapType: MapType.apple,
          destination: Coords(latitude, longitude),
          destinationTitle: title,
          origin: Coords(
            currentUser.value.location!.latitude!,
            currentUser.value.location!.longitude!,
          ),
          originTitle: 'You',
        );
      },
      child: Padding(
        padding: EdgeInsets.only(right: 15.w),
        child: Icon(
          FlutterRemix.treasure_map_fill,
          size: 24.h,
          color: context.theme.iconTheme.color,
        ),
      ),
    );
  }
}
