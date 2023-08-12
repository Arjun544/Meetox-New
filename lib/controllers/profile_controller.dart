import 'dart:developer';
import 'dart:io';

import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/helpers/get_asset_image.dart';
import 'package:meetox/models/profile_model.dart';
import 'package:meetox/models/user_model.dart';
import 'package:meetox/services/user_services.dart';

import 'global_controller.dart';

class ProfileController extends GetxController {
  final socialFormKey = GlobalKey<FormState>();
  final GlobalController globalController = Get.find();

  final Rx<ProfileModel> profile = ProfileModel().obs;
  final RxBool isLoading = false.obs;
  final RxBool removeSocialIsLoading = false.obs;
  final linkController = TextEditingController();
  final linkTextInput = ''.obs;
  final codeController = TextEditingController(text: '+');
  final numberFocusNode = FocusNode();
  final Rx<DateTime> selectedDOB = DateTime.now().obs;

  final RxString socialProfile = currentUser.value.photo!.obs;
  final RxInt selectedAvatar = 0.obs;
  Rx<XFile> capturedImage = XFile('').obs;
  Rx<FilePickerResult> selectedImage = const FilePickerResult([]).obs;

  @override
  void onInit() {
    getProfile();
    super.onInit();
  }

  void getProfile() async =>
      profile.value = await UserServices.profileDetails(isLoading);

  void handleChangeImage() async {
    File? base64Profile;
    if (socialProfile.value.isEmpty &&
        capturedImage.value.path.isEmpty &&
        selectedImage.value.files.isNotEmpty) {
      log('slected Imageg called');

      base64Profile = File(selectedImage.value.files[0].path!);
    }

    if (socialProfile.value.isEmpty &&
        selectedImage.value.files.isEmpty &&
        capturedImage.value.path.isNotEmpty) {
      log('captured Imageg called');

      base64Profile = File(capturedImage.value.path);
    }
    if (socialProfile.value.isEmpty &&
        selectedImage.value.files.isEmpty &&
        capturedImage.value.path.isEmpty) {
      log('Avatar Imageg called');

      final imageFromAsset = await getImageFileFromAssets(
        globalController.userAvatars[selectedAvatar.value],
      );
      log(imageFromAsset.path);

      base64Profile = File(imageFromAsset.path);
      final isSuccess = await UserServices.updateImage(
        isLoading: isLoading,
        file: base64Profile,
      );

      if (isSuccess) {
        Get.back();
      }
    }
  }

  void handleChangeDOB(BuildContext context) async {
    final bool isSuccess = await UserServices.updateDOB(
      isLoading,
      selectedDOB.value,
    );
    if (isSuccess == true) {
      profile.value.dob = selectedDOB.value;
      profile.refresh();

      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    }
  }

  void handleAddSocial(BuildContext context,
      {required String type, required String url}) async {
    final bool isSuccess = await UserServices.addSocial(
      isLoading,
      Social(
        type: type,
        url: type == 'whatsapp'
            ? codeController.text.trim() + linkController.text.trim()
            : linkController.text.trim(),
      ),
    );
    if (isSuccess == true) {
      linkController.clear();
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    }
  }

  void handleRemoveSocial(
    BuildContext context, {
    required String type,
  }) async {
    final bool isSuccess = await UserServices.deleteSocial(
      removeSocialIsLoading,
      type,
    );
    if (isSuccess == true) {
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    linkController.dispose();
    numberFocusNode.dispose();
    super.dispose();
  }
}
