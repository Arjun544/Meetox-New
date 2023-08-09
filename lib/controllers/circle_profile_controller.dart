import 'package:meetox/controllers/global_controller.dart';
import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/models/user_model.dart';
import 'package:meetox/services/follow_services.dart';

class CircleProfileController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final GlobalController globalController = Get.find();
  final GlobalKey<FormState> editFormKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  final followersPagingController =
      PagingController<int, UserModel>(firstPageKey: 1);

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

  @override
  void onClose() {
    followersPagingController.dispose();
    followersSearchDebounce.dispose();
    nameController.dispose();
    descController.dispose();
    super.onClose();
  }
}
