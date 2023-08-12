import 'package:meetox/controllers/circles_controller.dart';
import 'package:meetox/controllers/global_controller.dart';
import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/models/circle_model.dart';
import 'package:meetox/models/user_model.dart';
import 'package:meetox/services/circle_services.dart';
import 'package:meetox/services/follow_services.dart';
import 'package:meetox/services/user_services.dart';

class CircleProfileController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final GlobalController globalController = Get.find();
  final GlobalKey<FormState> editFormKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  final followersPagingController =
      PagingController<int, UserModel>(firstPageKey: 1);

  final Rx<CircleModel> circle = CircleModel().obs;
  final Rx<UserModel> admin = UserModel().obs;
  final RxInt members = 0.obs;
  final RxBool isPrivate = false.obs;
  final RxString nameText = ''.obs;
  final RxString descText = ''.obs;
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode descFocusNode = FocusNode();
  final RxInt selectedAvatar = 0.obs;
  Rx<XFile> capturedImage = XFile('').obs;
  Rx<FilePickerResult> selectedImage = const FilePickerResult([]).obs;

  final RxBool hasNameFocus = false.obs;
  final RxBool hasDescFocus = false.obs;

  final RxString followersSearchQuery = ''.obs;
  late Worker followersSearchDebounce;

  @override
  void onInit() {
    super.onInit();
    getAdmin();
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

  void getAdmin() async =>
      admin.value = await UserServices.userById(id: circle.value.adminId);

  void handleEdit(RxBool isLoading) async {
    //  if ((selectedImage.value[0] != circle.value.photo ||
    //           controller.nameText.value.toLowerCase() !=
    //               circle.value.name!.toLowerCase() ||
    //           controller.descText.value.toLowerCase() !=
    //               circle.value.description!.toLowerCase() ||
    //           controller.isPrivate.value != circle.value.isPrivate) &&
    //       controller.editFormKey.currentState!.validate()) {
    //     File? base64Profile;
    //     if (controller.capturedImage.value.path.isEmpty &&
    //         controller.selectedImage.value.files.isNotEmpty) {
    //       base64Profile = File(controller.selectedImage.value.files[0].path!);
    //     }

    //     if (controller.selectedImage.value.files.isEmpty &&
    //         controller.capturedImage.value.path.isNotEmpty) {
    //       base64Profile = File(controller.capturedImage.value.path);
    //     }
    //     if (controller.selectedImage.value.files.isEmpty &&
    //         controller.capturedImage.value.path.isEmpty) {
    //       final imageFromAsset = await getImageFileFromAssets(
    //         controller.globalController
    //             .circleAvatars[controller.selectedAvatar.value],
    //       );
    //       log(imageFromAsset.path);

    //       base64Profile = File(imageFromAsset.path);
    //     }
    await CircleServices.editCircle(
      isLoading: isLoading,
      circle: CircleModel(
        id: circle.value.id,
        name: nameController.text.trim(),
        description: descController.text.trim(),
        isPrivate: isPrivate.value,
      ),
      // file: circleAvatar.value != circle.value.photo ? base64Profile : null,
      onSuccess: (String data) {},
    );
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
    followersPagingController.dispose();
    followersSearchDebounce.dispose();
    nameController.dispose();
    descController.dispose();
    super.onClose();
  }
}
