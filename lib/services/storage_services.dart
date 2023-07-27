import 'dart:io';

import '../core/imports/packages_imports.dart';

import '../core/imports/core_imports.dart';

class StorageServices {
  static Future<String> uploadImage(
      RxBool isLoading, String folder, File file) async {
    try {
      isLoading(true);
      final path = await supabase.storage.from(folder).upload(
            '${supabase.auth.currentUser!.id}/profile',
            file,
          );

      final String publicUrl = supabase.storage.from('folder').getPublicUrl(
            path,
            transform: const TransformOptions(
              quality: 50,
            ),
          );
      isLoading(false);

      return publicUrl;
    } catch (e) {
      isLoading(false);

      logError(e.toString());
      rethrow;
    }
  }
}
