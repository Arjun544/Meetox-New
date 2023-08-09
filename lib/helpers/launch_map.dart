import 'package:meetox/core/imports/packages_imports.dart';

Future<void> launchMap(double latitude, double longitude) async {
  Uri googleUrl = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
  if (await canLaunchUrl(googleUrl)) {
    await launchUrl(googleUrl);
  } else {
    throw 'Could not open the map.';
  }
}
