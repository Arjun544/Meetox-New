import 'dart:developer';
import 'dart:io';

import 'package:meetox/controllers/circles_controller.dart';
import 'package:meetox/controllers/global_controller.dart';
import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/helpers/get_asset_image.dart';
import 'package:meetox/models/circle_model.dart';
import 'package:meetox/models/circle_profile_model.dart';
import 'package:meetox/models/user_model.dart';
import 'package:meetox/services/circle_services.dart';
import 'package:meetox/services/follow_services.dart';

class CircleProfileController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final GlobalController globalController = Get.find();
  final GlobalKey<FormState> editFormKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  final followersPagingController =
      PagingController<int, UserModel>(firstPageKey: 1);

  final Rx<CircleModel> circle = CircleModel().obs;
  final Rx<CircleProfileModel> profile = CircleProfileModel().obs;
  final RxBool isPrivate = false.obs;
  final RxString nameText = ''.obs;
  final RxString descText = ''.obs;
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode descFocusNode = FocusNode();
  final RxString socialProfile = ''.obs;
  final RxInt selectedAvatar = 0.obs;
  Rx<XFile> capturedImage = XFile('').obs;
  Rx<FilePickerResult> selectedImage = const FilePickerResult([]).obs;

  final RxBool hasNameFocus = false.obs;
  final RxBool hasDescFocus = false.obs;

  final RxString followersSearchQuery = ''.obs;
  Worker? followersSearchDebounce;

  @override
  void onInit() async {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      nameFocusNode.addListener(() {
        hasNameFocus.value = nameFocusNode.hasFocus;
      });
      descFocusNode.addListener(() {
        hasDescFocus.value = descFocusNode.hasFocus;
      });
    });
    followersPagingController.addPageRequestListener((page) async {
      await fetchFollowers(page);
      followersSearchDebounce = debounce(
        followersSearchQuery,
        (value) {
          followersPagingController.refresh();
        },
        time: const Duration(seconds: 2),
      );
    });
  }

  @override
  void onReady() async {
    getProfileDetails();
    super.onReady();
  }

  void getProfileDetails() async {
    profile.value = await CircleServices.getCircleProfile(
      id: circle.value.id!,
    );
    logError(profile.value.toJson().toString());
  }

  Future<void> fetchFollowers(int pageKey) async {
    try {
      final newPage = await FollowServices.getFollowersFollowings(
        id: supabase.auth.currentUser!.id,
        limit: pageKey,
        query: followersSearchQuery.value.isEmpty
            ? null
            : followersSearchQuery.value,
      );

      final newItems = newPage;
      final hasNextPage = newPage.isEmpty;

      if (!hasNextPage) {
        followersPagingController.appendLastPage(newItems);
      } else if (hasNextPage) {
        followersPagingController.appendPage(newItems, pageKey + 1);
      }
    } catch (e) {
      logError(e.toString());
      followersPagingController.error = e;
    }
  }

  void handleEdit(RxBool isLoading) async {
    if ((socialProfile.value.isEmpty ||
            nameText.value.toLowerCase() != profile.value.name!.toLowerCase() ||
            descText.value.toLowerCase() !=
                profile.value.description!.toLowerCase() ||
            isPrivate.value != profile.value.isPrivate) &&
        editFormKey.currentState!.validate()) {
      File? base64Profile;
      if (capturedImage.value.path.isEmpty &&
          selectedImage.value.files.isNotEmpty) {
        base64Profile = File(selectedImage.value.files[0].path!);
      }

      if (selectedImage.value.files.isEmpty &&
          capturedImage.value.path.isNotEmpty) {
        base64Profile = File(capturedImage.value.path);
      }
      if (selectedImage.value.files.isEmpty &&
          capturedImage.value.path.isEmpty) {
        final imageFromAsset = await getImageFileFromAssets(
          globalController.circleAvatars[selectedAvatar.value],
        );
        log(imageFromAsset.path);

        base64Profile = File(imageFromAsset.path);
      }
      await CircleServices.editCircle(
        isLoading: isLoading,
        circle: CircleProfileModel(
          id: circle.value.id,
          name: nameController.text.trim(),
          description: descController.text.trim(),
          isPrivate: isPrivate.value,
          photo: socialProfile.value.isNotEmpty ? null : circle.value.photo,
        ),
        file: socialProfile.value.isNotEmpty ? null : base64Profile!,
        onSuccess: (newCircle) {
          logSuccess('OnSuccess : ${newCircle.toJson().toString()}');
          if (newCircle.id != null) {
            circle.value.photo = newCircle.photo;
            circle.refresh();
            profile.value.name = newCircle.name;
            profile.value.description = newCircle.description;
            profile.value.photo = newCircle.photo;
            profile.value.isPrivate = newCircle.isPrivate;
            profile.refresh();
            final bool isRegistered = Get.isRegistered<CirclesController>();
            if (isRegistered) {
              logSuccess('isRegistered$isRegistered');
              final CirclesController circlesController = Get.find();
              circlesController.circlesPagingController.itemList![
                      circlesController.circlesPagingController.itemList!
                          .indexWhere(
                              (element) => element.id == newCircle.id)] =
                  CircleModel(
                id: newCircle.id,
                name: newCircle.name,
                photo: newCircle.photo,
                location: circle.value.location,
                members: circle.value.members,
              );
              circlesController.circlesPagingController
                  // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
                  .notifyListeners();
            }
            Get.back();
          }
        },
      );
    } else {
      logSuccess('Not allowed');
    }
  }

  void handleDelete(RxBool isLoading) async {
    await CircleServices.deleteCircle(
      id: circle.value.id!,
      isLoading: isLoading,
      onSuccess: (newId) {
        if (newId.isNotEmpty) {
          final bool circlesController = Get.isRegistered<CirclesController>();
          if (circlesController) {
            final CirclesController circlesController = Get.find();
            circlesController.circlesPagingController.itemList!
                .removeWhere((element) => element.id == newId);
            circlesController.circlesPagingController
                // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
                .notifyListeners();
          }
        }
      },
    );
  }

  @override
  void onClose() {
    if (followersSearchDebounce != null) followersSearchDebounce!.dispose();
    nameController.dispose();
    descController.dispose();
    super.onClose();
  }
}
