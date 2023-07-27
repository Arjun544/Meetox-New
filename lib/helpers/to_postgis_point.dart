import '../models/user_model.dart';

String? toPostGISPoint(LocationModel? location) {
  final double? longitude = location!.longitude;
  final double? latitude = location.latitude;
  if (longitude != null && latitude != null) {
    return 'POINT($longitude $latitude)';
  }
  return null;
}
