// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:meetox/controllers/conversation_controller.dart';
// import 'package:meetox/core/imports/packages_imports.dart';
// import 'package:meetox/models/conversation_model.dart';
// import 'package:meetox/screens/chat_screen/chat_screen.dart';
// import 'package:meetox/widgets/online_indicator.dart';
// import 'package:timeago/timeago.dart' as timeago;

// import '../../../core/imports/core_imports.dart';

// class ConversationTile extends GetView<ConversationController> {
//   final ConversationModel conversation;

//   const ConversationTile({super.key, required this.conversation});
//   @override
//   Widget build(BuildContext context) {
//     const bool hasLastMessageSeen = true;
//     // final bool hasLastMessageSeen = conversation.extra!
//     //     .where((element) => element.participant != currentUser.value.id)
//     //     .toList()[0]
//     //     .hasSeenLastMessage!;
//     return InkWell(
//       onTap: () {
//         Get.to(
//           () => ChatScreen(conversation: conversation),
//         );
//       },
//       child: ListTile(
//         contentPadding: EdgeInsets.zero,
//         leading: Stack(
//           children: [
//             Container(
//               height: 45.sp,
//               width: 45.sp,
//               decoration: BoxDecoration(
//                 color: context.theme.dividerColor,
//                 borderRadius: BorderRadius.circular(14),
//                 boxShadow: [
//                   BoxShadow(
//                     color:
//                         context.isDarkMode ? Colors.black : Colors.grey[400]!,
//                     blurRadius: 0.3,
//                   ),
//                 ],
//                 // image: DecorationImage(
//                 //   fit: BoxFit.cover,
//                 //   image: CachedNetworkImageProvider(
//                 //     conversation.participants![0].displayPic!.profile!,
//                 //   ),
//                 // ),
//               ),
//             ),
//             // OnlineIndicator(id: conversation.participants![0].id!),
//           ],
//         ),
//         title: Text(
//           conversation.participants![0].name!.capitalizeFirst!,
//           style: context.theme.textTheme.labelMedium,
//         ),
//         subtitle: Row(
//           children: [
//             conversation.lastMessage!.type == 'location'
//                 ? const Padding(
//                     padding: EdgeInsets.only(right: 5.0),
//                     child: Icon(
//                       FlutterRemix.map_pin_2_fill,
//                       size: 12,
//                     ),
//                   )
//                 : const SizedBox.shrink(),
//             GetUtils.isURL(conversation.lastMessage!.message!)
//                 ? const Padding(
//                     padding: EdgeInsets.only(right: 5.0),
//                     child: Icon(
//                       FlutterRemix.links_fill,
//                       size: 12,
//                     ),
//                   )
//                 : const SizedBox.shrink(),
//             Expanded(
//               child: Text(
//                 conversation.lastMessage!.message == null
//                     ? ''
//                     : conversation.lastMessage!.sender == currentUser.value.id
//                         ? "You: ${conversation.lastMessage!.message!.capitalizeFirst!}"
//                         : conversation.lastMessage!.message!.capitalizeFirst!,
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//                 style: context.theme.textTheme.labelSmall!.copyWith(
//                   color: context.theme.textTheme.labelSmall!.color!
//                       .withOpacity(hasLastMessageSeen ? 1 : 0.5),
//                   fontWeight:
//                       hasLastMessageSeen ? FontWeight.w700 : FontWeight.w500,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         trailing: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             Text(
//               timeago.format(
//                 conversation.lastMessage!.createdAt!,
//                 locale: 'en',
//                 allowFromNow: true,
//               ),
//               style: context.theme.textTheme.labelSmall!.copyWith(fontSize: 9),
//             ),
//             if (hasLastMessageSeen)
//               Container(
//                 height: 8,
//                 width: 8,
//                 decoration: const BoxDecoration(
//                   color: Colors.redAccent,
//                   shape: BoxShape.circle,
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
