import 'dart:developer';

import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/models/feed_model.dart';
import 'package:meetox/models/user_model.dart';
import 'package:meetox/services/storage_services.dart';

class FeedServices {
  static Future<void> addFeed({
    required RxBool isLoading,
    required Map<String, dynamic> data,
    required double lat,
    required double long,
    required void Function(bool) onSuccess,
  }) async {
    try {
      RxList<String> urls = <String>[].obs;
      isLoading(true);
      if (data['files'].isNotEmpty) {
        logInfo('files are not empty');

        for (var image in data['files']) {
          String url = await StorageServices.uploadImage(
            isLoading: isLoading,
            folder: 'feeds',
            subFolder: '${DateTime.now().millisecondsSinceEpoch}',
            file: image,
          );
          urls.value.add(url);
        }
      }

      logInfo('files are empty');

      if (urls.value.isNotEmpty) {
        await supabase.from('feeds').insert({
          'content': data['content'],
          'images': urls.value,
          'address': data['address'],
          'user_id': supabase.auth.currentUser!.id,
          'location': LocationModel(
            latitude: lat,
            longitude: long,
          ).toJSON(),
          'created_at': DateTime.now().toString(),
        });
        onSuccess(true);
        isLoading(false);
      } else {
        await supabase.from('feeds').insert({
          'content': data['content'],
          'address': data['address'],
          'user_id': supabase.auth.currentUser!.id,
          'location': LocationModel(
            latitude: lat,
            longitude: long,
          ).toJSON(),
          'created_at': DateTime.now().toString(),
        });
        onSuccess(true);
        isLoading(false);
      }
    } catch (e) {
      isLoading(false);
      logError('Circle created error ${e.toString()}');
    }
  }

  static Future<List<FeedModel>> getNearByFeeds({
    required double lat,
    required double long,
    required int limit,
  }) async {
    try {
      final data = await supabase.rpc(
        'nearby_feeds',
        params: {
          'lat': lat,
          'long': long,
          'perpage': limit,
          'distanceinkm': currentUser.value.isPremium == true ? 600 : 300,
        },
      );
      log('Nearby Feeds ${data.toString()}');
      return [];
    } catch (e) {
      logError('Get Feeds Error ${e.toString()}');
      rethrow;
    }
  }

  static Future<List<FeedModel>> getRecentFeeds({
    required double lat,
    required double long,
    required int limit,
  }) async {
    try {
      final data = await supabase.rpc(
        'recent_feeds',
        params: {
          'lat': lat,
          'long': long,
          'perpage': limit,
          'distanceinkm': currentUser.value.isPremium == true ? 600 : 300,
        },
      );
      log('Recent Feeds ${data.toString()}');
      return [];
    } catch (e) {
      logError('Get Feeds Error ${e.toString()}');
      rethrow;
    }
  }
}
