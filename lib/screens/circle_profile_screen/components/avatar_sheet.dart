import 'package:meetox/controllers/circle_profile_controller.dart';
import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/widgets/custom_button.dart';
import 'package:meetox/widgets/custom_sheet.dart';
import 'package:meetox/widgets/sheets/avatars_sheet.dart';

class AvatarSheet extends GetView<CircleProfileController> {
  final Rx<String> image;

  const AvatarSheet(this.image, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.35,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      decoration: BoxDecoration(
        color: context.theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          CustomButton(
            width: Get.width * 0.9,
            text: 'Choose from our avatars',
            hasIcon: true,
            color: context.theme.indicatorColor,
            icon: IconTheme(
              data: context.theme.iconTheme,
              child: const Icon(
                FlutterRemix.user_4_fill,
              ),
            ),
            onPressed: () {
              showCustomSheet(
                context: context,
                child: AvatarsSheet(
                  selectedAvatar: controller.selectedAvatar,
                  avatars: controller.globalController.circleAvatars,
                ),
              );
              controller.capturedImage.value = XFile('');
              controller.selectedImage.value = const FilePickerResult([]);
              image('');
            },
          ),
          SizedBox(height: 20.sp),
          CustomButton(
            width: Get.width * 0.9,
            text: 'Capture with camera',
            hasIcon: true,
            color: context.theme.indicatorColor,
            icon: IconTheme(
              data: context.theme.iconTheme,
              child: const Icon(
                FlutterRemix.camera_3_fill,
              ),
            ),
            onPressed: () async {
              controller.capturedImage.value = (await ImagePicker().pickImage(
                source: ImageSource.camera,
                imageQuality: 50,
              ))!;
              controller.selectedImage.value = const FilePickerResult([]);
              image('');
            },
          ),
          SizedBox(height: 20.sp),
          CustomButton(
            width: Get.width * 0.9,
            text: 'Choose from gallery',
            hasIcon: true,
            color: context.theme.indicatorColor,
            icon: IconTheme(
              data: context.theme.iconTheme,
              child: const Icon(
                FlutterRemix.image_2_fill,
              ),
            ),
            onPressed: () async {
              controller.selectedImage.value =
                  (await FilePicker.platform.pickFiles(
                type: FileType.image,
                withData: true,
              ))!;
              controller.capturedImage.value = XFile('');
              image('');
            },
          ),
        ],
      ),
    );
  }
}
