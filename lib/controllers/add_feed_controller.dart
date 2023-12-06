import 'dart:io';

import 'package:meetox/controllers/root_controller.dart';
import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/services/feed_services.dart';

class AddFeedController extends GetxController {
  final RootController rootController = Get.find();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController contentController = TextEditingController();
  RxList<XFile> capturedImages = <XFile>[].obs;
  Rx<FilePickerResult> selectedImages = const FilePickerResult([]).obs;

  final RxBool isPickingFiles = false.obs;
  final RxBool isLoading = false.obs;

  Future<void> handlePostFeed(BuildContext context) async {
    RxList<File> base64Images = <File>[].obs;

    if (capturedImages.value.isNotEmpty) {
      base64Images.value =
          capturedImages.value.map((image) => File(image.path)).toList();
    }

    if (selectedImages.value.files.isNotEmpty) {
      base64Images.value =
          selectedImages.value.files.map((image) => File(image.path!)).toList();
    }

    await FeedServices.addFeed(
      isLoading: isLoading,
      lat: rootController.currentPosition.value.latitude,
      long: rootController.currentPosition.value.longitude,
      data: {
        'content': contentController.text.trim(),
        'files': base64Images.value,
        'address': currentUser.value.address,
        'lat': currentUser.value.location!.latitude!,
        'long': currentUser.value.location!.longitude!,
      },
      onSuccess: (bool value) {
        if (value == true) {
          contentController.clear();

          capturedImages.value = [];
          selectedImages.value = const FilePickerResult([]);
          Navigator.pop(context);
          showToast('Post created successfully');
        }
      },
    );
  }
}
