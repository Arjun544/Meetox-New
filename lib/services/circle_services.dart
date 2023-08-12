import 'dart:convert';

import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/helpers/get_file_name.dart';
import 'package:meetox/models/circle_model.dart';
import 'package:meetox/models/user_model.dart';
import 'package:meetox/services/storage_services.dart';

class CircleServices {
  static Future<int> checkCount() async {
    try {
      final PostgrestResponse circles = await supabase
          .from('profiles')
          .select('', const FetchOptions(count: CountOption.exact))
          .eq('id', supabase.auth.currentUser!.id);

      return circles.count!;
    } catch (e) {
      logError(e.toString());
      rethrow;
    }
  }

  static Future<void> addCircle({
    required RxBool isLoading,
    required Map<String, dynamic> data,
    required double lat,
    required double long,
    required void Function(CircleModel) onSuccess,
  }) async {
    try {
      isLoading(true);
      final photoUrl = await StorageServices.uploadImage(
        isLoading: isLoading,
        folder: 'circle profiles',
        subFolder: '${DateTime.now().millisecondsSinceEpoch}',
        file: data['file'],
      );
      late dynamic newCircle;
      if (photoUrl.isNotEmpty) {
        newCircle = await supabase.from('circles').insert({
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
        }).select('*, circle_members(count)');

        if (newCircle.isNotEmpty) {
          // Add members
          for (var member in data['members']) {
            await supabase.from('circle_members').insert({
              'circle_id': newCircle[0]['id'],
              'member_id': member,
            });
          }
        }
      }
      // Updating members count manually
      final CircleModel editedCircle = CircleModel.fromJson(
        {
          ...newCircle[0],
          'circle_members': [
            CircleMember(
              count: data['members'].length,
            ).toJson()
          ],
        },
      );
      onSuccess(editedCircle);
      isLoading(false);
      return;
    } catch (e) {
      isLoading(false);
      logError('Circle created error ${e.toString()}');
      rethrow;
    }
  }

  static Future<List<CircleModel>> getCircles({
    required int limit,
    String? query,
  }) async {
    try {
      final List<CircleModel> circles = query != null
          ? await supabase
              .from('circles')
              .select(
                '*, circle_members(count)',
                const FetchOptions(
                  count: CountOption.exact,
                ),
              )
              .textSearch('fts', query)
              .eq('admin_id', supabase.auth.currentUser!.id)
              .order('created_at')
              .limit(10 * limit)
              .withConverter(
                (data) => List<CircleModel>.from(
                  data!.map((x) => CircleModel.fromJson(x)),
                ),
              )
          : await supabase
              .from('circles')
              .select(
                '*, circle_members(count)',
                const FetchOptions(
                  count: CountOption.exact,
                ),
              )
              .eq('admin_id', supabase.auth.currentUser!.id)
              .order('created_at')
              .limit(10 * limit)
              .withConverter(
                (data) => List<CircleModel>.from(
                  data!.map((x) => CircleModel.fromJson(x)),
                ),
              );
      logSuccess('$circles');
      return circles;
    } catch (e) {
      logError('Get Circles Error ${e.toString()}');
      rethrow;
    }
  }

  static Future<bool> isMember({
    required String id,
    required RxBool isLoading,
  }) async {
    try {
      isLoading.value = true;
      final data = await supabase
          .from('circle_members')
          .select()
          .eq('member_id', currentUser.value.id)
          .eq('circle_id', id);

      logSuccess(data.toString());
      isLoading.value = false;

      if (data.isEmpty) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      logError(e.toString());
      rethrow;
    }
  }

  static Future<void> join({
    required String id,
    required RxBool isLoading,
    required void Function(bool) onSuccess,
  }) async {
    try {
      isLoading.value = true;
      await supabase
          .from('circle_members')
          .insert({'member_id': currentUser.value.id, 'circle_id': id});

      isLoading.value = false;
      onSuccess(true);
    } catch (e) {
      isLoading.value = false;
      logError(e.toString());
    }
  }

  static Future<void> leave({
    required String id,
    required RxBool isLoading,
    required void Function(bool) onSuccess,
  }) async {
    try {
      isLoading.value = true;
      await supabase
          .from('circle_members')
          .delete()
          .eq('member_id', currentUser.value.id)
          .eq('circle_id', id);

      isLoading.value = false;
      onSuccess(true);
    } catch (e) {
      isLoading.value = false;
      logError(e.toString());
      rethrow;
    }
  }

  static Future<void> editCircle({
    required RxBool isLoading,
    required CircleModel circle,
    required void Function(String) onSuccess,
  }) async {
    try {
      isLoading.value = true;
      final PostgrestTransformBuilder data = await supabase
          .from('circles')
          .update(
            circle.toJson(),
          )
          .eq('id', circle.id)
          .select();
      // await StorageServices.deleteImage(
      //   folder: 'circle profiles',
      //   name: getFileName(data[0]['photo']),
      // );
      isLoading.value = false;
      onSuccess(data.toString());
    } catch (e) {
      logError(e.toString());
    }
  }

  static Future<void> deleteCircle({
    required String id,
    required RxBool isLoading,
    required void Function(String) onSuccess,
  }) async {
    try {
      isLoading.value = true;
      final List<Map<String, dynamic>> data = await supabase
          .from('circles')
          .delete()
          .match({'id': id}).select('id, photo');
      logSuccess('Delete circle ${data[0]}');
      await StorageServices.deleteImage(
        folder: 'circle profiles',
        name: getFileName(data[0]['photo']),
      );
      isLoading.value = false;
      onSuccess(data[0]['id'].toString());
    } catch (e) {
      isLoading.value = false;
      showToast('Delete circle failed');
      logError(e.toString());
    }
  }

  static Future<List<CircleModel>> getNearByCircles({
    required double lat,
    required double long,
    required double distanceInKm,
  }) async {
    try {
      final List<dynamic> data = await supabase.rpc(
        'nearby_circles',
        params: {
          'lat': lat,
          'long': long,
          'distanceinkm': distanceInKm,
        },
      );
      logError('Nearby Circles ${data.toString()}');

      final List<CircleModel> circles = data
          .map((e) => CircleModel.fromJson({
                'id': e['id'],
                'name': e['name'],
                'photo': e['photo'],
                'address': e['address'],
                'isprivate': e['isprivate'],
                'limit': e['limit'],
                'circle_members': [
                  CircleMember(
                    count: e['members'],
                  ).toJson()
                ],
                'location': LocationModel.fromJSON(
                        jsonDecode(e['location']) as Map<String, dynamic>)
                    .toJSON(),
                'admin_id': e['admin_id'],
                'updated_at': e['updated_at'],
                'created_at': e['created_at'],
              }))
          .toList();
      return circles;
    } catch (e) {
      logError('Nearby Circles ${e.toString()}');
      rethrow;
    }
  }
}
