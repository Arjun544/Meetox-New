import 'package:cached_network_image/cached_network_image.dart';
import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/widgets/online_indicator.dart';

import '../../../core/imports/packages_imports.dart';
import '../../../models/user_model.dart';

AppBar chatHeader(BuildContext context, UserModel user) {
  final RxBool isTyping = false.obs;

  return AppBar(
    elevation: 0,
    backgroundColor: context.theme.indicatorColor,
    title: Row(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 18.sp,
              backgroundColor: AppColors.primaryYellow,
              foregroundImage: CachedNetworkImageProvider(
                  user.photo! == '' ? profilePlaceHolder : user.photo!),
            ),
            OnlineIndicator(id: user.id!),
          ],
        ),
        SizedBox(width: 20.sp),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.name == '' ? 'Unknown' : user.name!,
              style: context.theme.textTheme.labelSmall,
            ),
            const SizedBox(height: 2),
            Obx(
              () => Text(
                isTyping.value ? 'typing...' : 'Tap to view profile',
                style: context.theme.textTheme.labelSmall!
                    .copyWith(fontSize: 10, color: Colors.blue),
              ),
            ),
          ],
        ),
      ],
    ),
    leading: GestureDetector(
      onTap: () {
        Get.back();
        // if (conversationController.id.value.isNotEmpty &&
        //     isTyping.value == true) {
        //   userNameSpace.emit('typing_off', {
        //     'receiverId': user.id,
        //     'room': conversationController.currentConversationId.value,
        //   });
        // }
      },
      child: const Icon(Icons.arrow_back_ios_new_rounded),
    ),
  );
}
