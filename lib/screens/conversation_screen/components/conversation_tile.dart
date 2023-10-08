import 'package:cached_network_image/cached_network_image.dart';
import 'package:meetox/controllers/conversation_controller.dart';
import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/models/conversation_model.dart';
import 'package:meetox/models/message_model.dart';
import 'package:meetox/models/user_model.dart';
import 'package:meetox/screens/chat_screen/chat_screen.dart';
import 'package:meetox/widgets/online_indicator.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../core/imports/core_imports.dart';

class ConversationTile extends StatefulWidget {
  final ConversationModel conversation;

  const ConversationTile({super.key, required this.conversation});

  @override
  State<ConversationTile> createState() => _ConversationTileState();
}

class _ConversationTileState extends State<ConversationTile> {
  final ConversationController controller = Get.find();
  final RxString conversationName = ''.obs;
  final RxString conversationPhoto = ''.obs;
  final RxString participantId = ''.obs;
  final bool hasLastMessageSeen = true;

  late PostgrestFilterBuilder userDetailsFuture;
  late PostgrestFilterBuilder circleDetailsFuture;

  @override
  void initState() {
    userDetailsFuture = supabase.from('profiles').select('id, name, photo').eq(
        'id',
        widget.conversation.participants!
            .firstWhere((participant) => participant != currentUser.value.id));
    circleDetailsFuture = supabase
        .from('profiles')
        .select('id, name, photo')
        .eq('id', widget.conversation.circleId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final bool hasLastMessageSeen = conversation.extra!
    //     .where((element) => element.participant != currentUser.value.id)
    //     .toList()[0]
    //     .hasSeenLastMessage!;
    return InkWell(
      onTap: () {
        Get.to(
          () => ChatScreen(
            conversation: widget.conversation,
            user: UserModel(
              id: widget.conversation.participants!.firstWhere(
                  (participant) => participant != currentUser.value.id),
              name: conversationName.value,
              photo: conversationPhoto.value,
            ),
          ),
        );
      },
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Stack(
          children: [
            FutureBuilder(
              future: widget.conversation.type == ConversationType.oneToOne
                  ? userDetailsFuture
                  : circleDetailsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  logInfo(snapshot.data.toString());
                  participantId(snapshot.data![0]['id']);
                  conversationName(snapshot.data![0]['name']);
                  conversationPhoto(snapshot.data![0]['photo']);
                }

                return Container(
                  height: 45.sp,
                  width: 45.sp,
                  decoration: BoxDecoration(
                    color: context.theme.dividerColor,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: context.isDarkMode
                            ? Colors.black
                            : Colors.grey[400]!,
                        blurRadius: 0.3,
                      ),
                    ],
                    image: snapshot.connectionState == ConnectionState.waiting
                        ? null
                        : DecorationImage(
                            fit: BoxFit.cover,
                            image: CachedNetworkImageProvider(
                              snapshot.data![0]['photo'],
                            ),
                          ),
                  ),
                );
              },
            ),
            if (widget.conversation.type == ConversationType.oneToOne)
              OnlineIndicator(id: participantId.value),
          ],
        ),
        title: Obx(
          () => Text(
            conversationName.value,
            style: context.theme.textTheme.labelMedium,
          ),
        ),
        subtitle: Row(
          children: [
            widget.conversation.lastMessage!.type == MessageType.location
                ? const Padding(
                    padding: EdgeInsets.only(right: 5.0),
                    child: Icon(
                      FlutterRemix.map_pin_2_fill,
                      size: 12,
                    ),
                  )
                : const SizedBox.shrink(),
            GetUtils.isURL(widget.conversation.lastMessage!.content!)
                ? const Padding(
                    padding: EdgeInsets.only(right: 5.0),
                    child: Icon(
                      FlutterRemix.links_fill,
                      size: 12,
                    ),
                  )
                : const SizedBox.shrink(),
            Expanded(
              child: Text(
                widget.conversation.lastMessage!.content == null
                    ? ''
                    : widget.conversation.lastMessage!.senderId ==
                            currentUser.value.id
                        ? "You: ${widget.conversation.lastMessage!.content!.capitalizeFirst!}"
                        : widget.conversation.lastMessage!.content!
                            .capitalizeFirst!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: context.theme.textTheme.labelSmall!.copyWith(
                  color: context.theme.textTheme.labelSmall!.color!
                      .withOpacity(hasLastMessageSeen ? 1 : 0.5),
                  fontWeight:
                      hasLastMessageSeen ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              timeago.format(
                widget.conversation.lastMessage!.createdAt!,
                locale: 'en',
                allowFromNow: true,
              ),
              style: context.theme.textTheme.labelSmall!.copyWith(fontSize: 9),
            ),
            if (hasLastMessageSeen)
              Container(
                height: 8,
                width: 8,
                decoration: const BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
