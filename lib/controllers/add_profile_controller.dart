import 'dart:developer';
import 'dart:io';

import 'package:fl_query/fl_query.dart';

import '../core/imports/core_imports.dart';
import '../core/imports/packages_imports.dart';
import '../helpers/get_asset_image.dart';
import '../helpers/url_to_file.dart';
import 'global_controller.dart';

class AddProfileController extends GetxController
    with GetTickerProviderStateMixin {
  final GlobalController globalController = Get.find();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final PageController pageController = PageController();
  late TabController tabController;
  final RxInt selectedTab = 0.obs;

  final RxBool isLoading = false.obs;
  final RxString socialProfile = ''.obs;

  final TextEditingController nameController = TextEditingController();

  final FocusNode nameFocusNode = FocusNode();

  final RxBool hasNameFocus = true.obs;

  final RxInt currentStep = 1.obs;
  final RxInt selectedAvatar = 0.obs;
  final Rx<DateTime> birthDate = DateTime.now()
      .subtract(const Duration(days: 2922))
      .obs; // current year subtract 8 years
  Rx<XFile> capturedImage = XFile('').obs;
  Rx<FilePickerResult> selectedImage = const FilePickerResult([]).obs;

  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      nameFocusNode
        ..requestFocus()
        ..addListener(() {
          hasNameFocus.value = nameFocusNode.hasFocus;
        });
    });
    tabController = TabController(length: 2, vsync: this);
    super.onInit();
  }

  Future<void> handleSubmit(
      Mutation<void, Object?, Map<String, dynamic>> addProfileMutation) async {
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
    }

    isLoading(true);
    await addProfileMutation.mutate({
      'isLoading': isLoading,
      'name': nameController.text.trim(),
      'dob': birthDate.value.toUtc().toIso8601String(),
      'file': socialProfile.value.isNotEmpty
          ? await urlToFile(socialProfile.value)
          : base64Profile,
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    nameController.dispose();
    nameFocusNode.dispose();
    selectedImage.dispose();
    capturedImage.dispose();
    super.dispose();
  }
}
