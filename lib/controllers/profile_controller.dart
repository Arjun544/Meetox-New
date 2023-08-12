import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/models/profile_model.dart';
import 'package:meetox/models/user_model.dart';
import 'package:meetox/services/user_services.dart';

class ProfileController extends GetxController {
  final socialFormKey = GlobalKey<FormState>();

  final RxBool isLoading = false.obs;
  final RxBool removeSocialIsLoading = false.obs;
  final Rx<ProfileModel> profile = ProfileModel().obs;
  final linkController = TextEditingController();
  final linkTextInput = ''.obs;
  final codeController = TextEditingController(text: '+');
  final numberFocusNode = FocusNode();
  final Rx<DateTime> selectedDOB = DateTime.now().obs;

  @override
  void onInit() {
    getProfile();
    super.onInit();
  }

  void getProfile() async =>
      profile.value = await UserServices.profileDetails(isLoading);

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
}
