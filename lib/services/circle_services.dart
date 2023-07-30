import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/models/user_model.dart';
import 'package:meetox/services/storage_services.dart';

class CircleServices {
  static Future<bool> addCircle({
    required RxBool isLoading,
    required Map<String, dynamic> data,
    required double lat,
    required double long,
  }) async {
    try {
      isLoading(true);
      final photoUrl = await StorageServices.uploadImage(
        isLoading: isLoading,
        folder: 'circle profiles',
        subFolder: '${DateTime.now().millisecondsSinceEpoch}/profile',
        file: data['file'],
      );
      if (photoUrl.isNotEmpty) {
        final newCircle = await supabase.from('circles').insert({
          'name': data['name'],
          'description': data['description'],
          'photo': photoUrl,
          'isprivate': data['isPrivate'],
          'limit': int.parse(data['limit'].toString()),
          'address': data['address'],
          'admin_id': supabase.auth.currentUser!.id,
          'location': LocationModel(
            latitude: lat,
            longitude: long,
          ).toJSON(),
          'updated_at': DateTime.now().toString(),
        }).select('id');

        for (var member in data['members']) {
          await supabase.from('circle_members').insert({
            'circle_id': newCircle[0]['id'],
            'member_id': member,
          });
        }
      }

      isLoading(false);

      return true;
    } catch (e) {
      isLoading(false);
      logError('Circle created error ${e.toString()}');
      rethrow;
    }
  }
}
