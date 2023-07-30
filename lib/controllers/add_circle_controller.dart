import 'dart:developer';
import 'dart:io';

import 'package:fl_query/fl_query.dart';
import 'package:meetox/controllers/global_controller.dart';
import 'package:meetox/controllers/root_controller.dart';
import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/helpers/get_asset_image.dart';

class AddCircleController extends GetxController {
  final GlobalController globalController = Get.find();
  // final followersPagingController =
  //     PagingController<int, User>(firstPageKey: 1);
  final RootController rootController = Get.find();
  final PageController pageController = PageController();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode descFocusNode = FocusNode();

  final RxBool hasNameFocus = false.obs;
  final RxBool hasDescFocus = false.obs;

  final RxBool isLoading = false.obs;
  final RxInt currentStep = 0.obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final RxBool isPrivate = false.obs;
  final RxDouble limit = 50.0.obs;
  final RxInt selectedAvatar = 0.obs;
  Rx<XFile> capturedImage = XFile('').obs;
  Rx<FilePickerResult> selectedImage = const FilePickerResult([]).obs;
  final RxList<User> selectedMembers = <User>[].obs;

  final RxString followersSearchQuery = ''.obs;
  late Worker followersSearchDebounce;

  @override
  void onInit() {
    // followersPagingController.addPageRequestListener((page) async {
    //   await fetchFollowers(page);
    //   followersSearchDebounce = debounce(
    //     followersSearchQuery,
    //     (value) {
    //       followersPagingController.refresh();
    //     },
    //     time: const Duration(seconds: 2),
    //   );
    // });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      nameFocusNode.addListener(() {
        hasNameFocus.value = nameFocusNode.hasFocus;
      });
      descFocusNode.addListener(() {
        hasDescFocus.value = descFocusNode.hasFocus;
      });
    });

    super.onInit();
  }

  // Future<void> fetchFollowers(int pageKey) async {
  //   try {
  //     final newPage = await FollowServices.userFollowers(
  //       id: currentUser.value.id!,
  //       page: pageKey,
  //       name: followersSearchQuery.value.isEmpty
  //           ? null
  //           : followersSearchQuery.value,
  //     );

  //     final newItems = newPage.followers;

  //     if (newPage.nextPage == null &&
  //         !newPage.hasNextPage! &&
  //         newPage.nextPage == newPage.page) {
  //       followersPagingController.appendLastPage(newItems!);
  //     } else if (followersPagingController.nextPageKey != newPage.nextPage) {
  //       followersPagingController.appendPage(newItems!, newPage.nextPage);
  //     }
  //   } catch (e) {
  //     logError(e.toString());
  //     followersPagingController.error = e;
  //   }
  // }

  Future<void> handleAddCircle(BuildContext context,
      Mutation<void, Object?, Map<String, dynamic>> addCircleMutation) async {
    File? base64Profile;
    if (capturedImage.value.path.isEmpty &&
        selectedImage.value.files.isNotEmpty) {
      base64Profile = File(selectedImage.value.files[0].path!);
    }

    if (selectedImage.value.files.isEmpty &&
        capturedImage.value.path.isNotEmpty) {
      base64Profile = File(capturedImage.value.path);
    }
    if (selectedImage.value.files.isEmpty && capturedImage.value.path.isEmpty) {
      final imageFromAsset = await getImageFileFromAssets(
        globalController.circleAvatars[selectedAvatar.value],
      );
      log(imageFromAsset.path);

      base64Profile = File(imageFromAsset.path);
    }

    // Takes selected members and maps each element to its id, then creates a new list with the ids and inserts the current user's id at the beginning of the list.
    final members = selectedMembers
        .map<String>((element) => element.id)
        .toList()
      ..insert(0, currentUser.value.id!);

    addCircleMutation.mutate({
      'name': nameController.text.trim(),
      'description': descController.text.trim(),
      'file': base64Profile,
      'isPrivate': isPrivate.value,
      'limit': limit.value.toInt(),
      'members': members,
      'address': currentUser.value.address,
      'lat': currentUser.value.location!.latitude!,
      'long': currentUser.value.location!.longitude!,
    });
  }

  // void onComplete(Map<String, dynamic>? resultData) {
  //   if (resultData != null) {
  //     logSuccess(resultData.toString());
  //     final bool hasCirclesController = Get.isRegistered<CirclesController>();
  //     if (hasCirclesController) {
  //       final circle_model.Circle newCircle = circle_model.Circle.fromJson(
  //           resultData['addCircle'] as Map<String, dynamic>);
  //       final CirclesController circlesController = Get.find();

  //       circlesController.circlesPagingController.itemList!
  //           .insert(0, newCircle);
  //       circlesController.circlesPagingController
  //           // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
  //           .notifyListeners();
  //     }

  //     currentStep.value = 0;
  //     nameController.clear();
  //     descController.clear();
  //     isPrivate.value = false;
  //     limit.value = 50.0;
  //     selectedAvatar.value = 0;
  //     capturedImage.value = XFile('');
  //     selectedImage.value = const FilePickerResult([]);
  //     selectedMembers.clear();
  //     Get.back();
  //   }
  // }

  @override
  void dispose() {
    pageController.dispose();
    followersSearchDebounce.dispose();
    // followersPagingController.dispose();
    // followersPagingController.dispose();
    followersSearchDebounce.dispose();
    nameController.dispose();
    descController.dispose();
    nameFocusNode.dispose();
    descFocusNode.dispose();
    super.dispose();
  }
}
