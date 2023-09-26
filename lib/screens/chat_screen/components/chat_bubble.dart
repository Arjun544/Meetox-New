import 'dart:math' as math;
import 'package:timeago/timeago.dart' as timeago;

import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/models/message_model.dart';
import 'package:meetox/screens/chat_screen/components/link_bubble.dart';
import '../../../core/imports/core_imports.dart';
import 'chat_shape.dart';
import 'location_bubble.dart';

class ChatBubble extends StatelessWidget {
  final MessageModel msg;

  const ChatBubble({super.key, required this.msg});
  @override
  Widget build(BuildContext context) {
    const bool isMe = true;
    // final bool isMe = msg.senderId!.id == currentUser.value.id;
    return isMe == true
        ? Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: Get.width * 0.75,
                        ),
                        padding: EdgeInsets.all(
                            msg.type == MessageType.location ? 6 : 14),
                        margin: const EdgeInsets.only(bottom: 6),
                        decoration: const BoxDecoration(
                          color: AppColors.primaryYellow,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(18),
                            bottomLeft: Radius.circular(18),
                            bottomRight: Radius.circular(18),
                          ),
                        ),
                        child: GetUtils.isURL(msg.content!)
                            ? LinkPreviewBubble(link: msg.content!)
                            : msg.type == MessageType.location
                                ? LocationBubble(
                                    msg: msg,
                                  )
                                : Text(
                                    msg.content!,
                                    style: context.theme.textTheme.labelSmall,
                                  ),
                      ),
                    ),
                    CustomPaint(painter: CustomShape(AppColors.primaryYellow)),
                  ],
                ),
                Text(
                  timeago.format(
                    msg.createdAt!,
                    locale: 'en',
                    allowFromNow: true,
                  ),
                  style: context.theme.textTheme.labelSmall!.copyWith(
                    fontSize: 6.sp,
                    color: context.theme.textTheme.labelSmall!.color!
                        .withOpacity(0.7),
                  ),
                ),
              ],
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(math.pi),
                      child: CustomPaint(
                        painter:
                            CustomShape(context.theme.scaffoldBackgroundColor),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: Get.width * 0.75,
                        ),
                        padding: EdgeInsets.all(
                            msg.type == MessageType.location ? 6 : 14),
                        margin: const EdgeInsets.only(bottom: 6),
                        decoration: BoxDecoration(
                          color: context.theme.indicatorColor,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(18),
                            bottomLeft: Radius.circular(18),
                            bottomRight: Radius.circular(18),
                          ),
                        ),
                        child: GetUtils.isURL(msg.content!)
                            ? LinkPreviewBubble(link: msg.content!)
                            : msg.type == MessageType.location
                                ? LocationBubble(
                                    msg: msg,
                                  )
                                : Text(
                                    msg.content!,
                                    style: context.theme.textTheme.labelSmall,
                                  ),
                      ),
                    ),
                  ],
                ),
                Text(
                  timeago.format(
                    msg.createdAt!,
                    locale: 'en',
                    allowFromNow: true,
                  ),
                  style: context.theme.textTheme.labelSmall!.copyWith(
                    fontSize: 6.sp,
                    color: context.theme.textTheme.labelSmall!.color!
                        .withOpacity(0.7),
                  ),
                ),
              ],
            ),
          );
  }
}
