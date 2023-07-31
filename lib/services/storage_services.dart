import 'dart:io';

import '../core/imports/core_imports.dart';

class StorageServices {
  static Future<String> uploadImage({
    required RxBool isLoading,
    required String folder,
    required String subFolder,
    required File file,
  }) async {
    try {
      isLoading(true);
      await supabase.storage.from(folder).upload(
            subFolder,
            file,
          );

      final String publicUrl =
          supabase.storage.from(folder).getPublicUrl(subFolder);
      isLoading(false);
      return publicUrl;
    } catch (e) {
      isLoading(false);

      logError(e.toString());
      rethrow;
    }
  }
}
