import 'package:meetox/controllers/add_feed_controller.dart';
import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/widgets/custom_button.dart';

class SelectImageSheet extends GetView<AddFeedController> {
  const SelectImageSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.25,
      width: Get.width,
      padding: EdgeInsets.only(top: 20.h),
      decoration: BoxDecoration(
        color: context.theme.dialogBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          CustomButton(
            width: Get.width * 0.9,
            text: 'Capture with camera',
            hasIcon: true,
            color: context.theme.scaffoldBackgroundColor,
            icon: IconTheme(
              data: context.theme.iconTheme,
              child: const Icon(
                FlutterRemix.camera_3_fill,
              ),
            ),
            onPressed: () async {
              Navigator.pop(context);
              final image = (await ImagePicker().pickImage(
                source: ImageSource.camera,
                imageQuality: 50,
              ))!;
              controller.capturedImages.value.insert(0, image);
              // ignore: invalid_use_of_protected_member
              controller.capturedImages.refresh();
              controller.selectedImages.value = const FilePickerResult([]);
            },
          ),
          SizedBox(height: 20.sp),
          CustomButton(
            width: Get.width * 0.9,
            text: 'Choose from gallery',
            hasIcon: true,
            color: Get.theme.scaffoldBackgroundColor,
            icon: IconTheme(
              data: Get.theme.iconTheme,
              child: const Icon(
                FlutterRemix.image_2_fill,
              ),
            ),
            onPressed: () async {
              Navigator.pop(context);
              controller.selectedImages.value =
                  (await FilePicker.platform.pickFiles(
                type: FileType.image,
                withData: true,
                allowMultiple: true,
                onFileLoading: (status) {
                  if (status == FilePickerStatus.picking) {
                    controller.isPickingFiles.value = true;
                  } else {
                    controller.isPickingFiles.value = false;
                  }
                },
              ))!;
              controller.capturedImages.value = [];
            },
          ),
        ],
      ),
    );
  }
}
