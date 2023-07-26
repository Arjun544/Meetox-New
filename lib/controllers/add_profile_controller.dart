

import 'package:fl_query/fl_query.dart';
import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';

import 'global_controller.dart';

class AddProfileController extends GetxController
    with GetTickerProviderStateMixin {
  final GlobalController globalController = Get.find();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final PageController pageController = PageController();
  late TabController tabController;
  final RxInt selectedTab = 0.obs;

  final RxString currentLoginProvider = ''.obs;
  final RxBool isSocialProfileLoading = false.obs;

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
      Mutation<UserResponse, Object?, Object?> addProfileMutation) async {
    // String? base64Profile;
    // if (socialProfile.value.isEmpty &&
    //     capturedImage.value.path.isEmpty &&
    //     selectedImage.value.files.isNotEmpty) {
    //   log('slected Imageg called');

    //   base64Profile =
    //       convertIntoBase64Image(selectedImage.value.files[0].path!);
    // }

    // if (socialProfile.value.isEmpty &&
    //     selectedImage.value.files.isEmpty &&
    //     capturedImage.value.path.isNotEmpty) {
    //   log('captured Imageg called');

    //   base64Profile = convertIntoBase64Image(capturedImage.value.path);
    // }
    // if (socialProfile.value.isEmpty &&
    //     selectedImage.value.files.isEmpty &&
    //     capturedImage.value.path.isEmpty) {
    //   log('Avatar Imageg called');

    //   final imageFromAsset = await getImageFileFromAssets(
    //     globalController.userAvatars[selectedAvatar.value],
    //   );
    //   log(imageFromAsset.path);

    //   base64Profile = convertIntoBase64Image(imageFromAsset.path);
    // }


    // addProfileMutation.mutate({
    //   'name': nameController.text.trim(),
    //   'birthDate': birthDate.value.toUtc().toString(),
    //   'profile':
    //       socialProfile.value.isNotEmpty ? socialProfile.value : base64Profile,
    // });
  }
}
