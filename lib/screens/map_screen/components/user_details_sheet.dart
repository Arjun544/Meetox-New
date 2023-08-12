// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:meetox/controllers/map_controller.dart';
// import 'package:meetox/core/imports/core_imports.dart';
// import 'package:meetox/core/imports/packages_imports.dart';
// import 'package:meetox/helpers/get_distance.dart';
// import 'package:meetox/models/user_model.dart';
// import 'package:meetox/screens/followers_screen/followers_screen.dart';
// import 'package:meetox/widgets/follow_button.dart';
// import 'package:meetox/widgets/navigate_button.dart';
// import 'package:meetox/widgets/online_indicator.dart';

// import '../../user_profile_screen/user_profile_screen.dart';

// class UserDetailsSheet extends GetView<MapScreenController> {
//   const UserDetailsSheet(this.user, this.tappedUser, {super.key});
//   final UserModel user;
//   final Rx<UserModel> tappedUser;

//   @override
//   Widget build(BuildContext context) {
//     final RxInt followersCount = user.followers!.obs;

//     final currentLatitude =
//         controller.rootController.currentPosition.value.latitude;
//     final currentLongitude =
//         controller.rootController.currentPosition.value.longitude;
//     final userLatitude = user.location!.latitude!;
//     final userLongitude = user.location!.longitude!;

//     final distanceBtw = getDistance(
//       currentLatitude,
//       currentLongitude,
//       userLatitude,
//       userLongitude,
//     );

//     // final checkHasConversation = useMutation(
//     //   MutationOptions(
//     //     document: gql(hasConversation),
//     //     fetchPolicy: FetchPolicy.networkOnly,
//     //     onCompleted: (data) {
//     //       logSuccess(data!['hasConversation'].toString());
//     //       final hasConversation = data['hasConversation']['hasConversation'];
//     //       if (hasConversation) {
//     //         final Conversation conversation =
//     //             Conversation.fromJson(data['hasConversation']['conversation']);
//     //         Get.to(() => ChatScreen(conversation: conversation));
//     //       } else {
//     //         Get.to(
//     //           () => ChatScreen(
//     //               conversation: Conversation(
//     //             id: null,
//     //             participants: [user],
//     //           )),
//     //         );
//     //       }
//     //     },
//     //   ),
//     // );

//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       controller.animatedMapMove(
//         LatLng(
//           user.location!.latitude!,
//           user.location!.longitude!,
//         ),
//         14,
//       );
//     });
//     return Stack(
//       children: [
//         GestureDetector(
//           onTap: () {
//             controller.isFiltersVisible.value = true;
//             tappedUser.value = UserModel();
//             Navigator.pop(context);
//           },
//           child: Container(
//             height: Get.height,
//             width: Get.width,
//             color: Colors.transparent,
//           ),
//         ),
//         Container(
//           width: Get.width,
//           margin: EdgeInsets.only(top: Get.height * 0.55),
//           decoration: BoxDecoration(
//             color: context.theme.scaffoldBackgroundColor,
//             borderRadius: BorderRadius.circular(30),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               Center(
//                 child: Container(
//                   height: 5.sp,
//                   width: 70.sp,
//                   decoration: BoxDecoration(
//                     color:
//                         context.theme.bottomNavigationBarTheme.backgroundColor,
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 40,
//                 child: ListTile(
//                   dense: true,
//                   contentPadding: EdgeInsets.zero,
//                   horizontalTitleGap: 16,
//                   leading: Padding(
//                     padding: const EdgeInsets.only(left: 16),
//                     child: Stack(
//                       children: [
//                         SizedBox(
//                           width: 50,
//                           height: 70,
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(14),
//                             child: CachedNetworkImage(
//                               imageUrl: user.photo!.isEmpty
//                                   ? profilePlaceHolder
//                                   : user.photo!,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         ),
//                         OnlineIndicator(
//                           id: user.id!,
//                         ),
//                       ],
//                     ),
//                   ),
//                   title: Text(
//                     user.name == '' ? 'Unknown' : user.name!.capitalizeFirst!,
//                     style: context.theme.textTheme.labelMedium,
//                   ),
//                   subtitle: Text(
//                     user.address?.capitalizeFirst ?? 'Unknown',
//                     style: context.theme.textTheme.labelSmall!.copyWith(
//                       color: Colors.grey,
//                     ),
//                   ),
//                   trailing: FollowButton(
//                     id: user.id!,
//                     followers: followersCount,
//                   ),
//                 ),
//               ),
//               SizedBox(height: 10.h),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       if (followersCount.value != 0) {
//                         Get.to(() => FollowersScreen(user, false));
//                       }
//                     },
//                     child: Column(
//                       children: [
//                         Obx(
//                           () => Text(
//                             followersCount.value.toString(),
//                             style: context.theme.textTheme.labelMedium,
//                           ),
//                         ),
//                         Text(
//                           'Followers',
//                           style: context.theme.textTheme.labelSmall!
//                               .copyWith(color: Colors.grey),
//                         ),
//                       ],
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       if (user.followings != 0) {
//                         Get.to(() => FollowersScreen(user, true));
//                       }
//                     },
//                     child: Column(
//                       children: [
//                         Text(
//                           user.followings.toString(),
//                           style: context.theme.textTheme.labelMedium,
//                         ),
//                         Text(
//                           'Followings',
//                           style: context.theme.textTheme.labelSmall!
//                               .copyWith(color: Colors.grey),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               Padding(
//                 padding:
//                     EdgeInsets.symmetric(horizontal: 15.sp, vertical: 20.sp),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     Expanded(
//                       flex: 2,
//                       child: Container(
//                         height: 45.sp,
//                         decoration: BoxDecoration(
//                           color: context.theme.indicatorColor,
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             Icon(
//                               FlutterRemix.pin_distance_fill,
//                               size: 22.sp,
//                               color: context.theme.iconTheme.color,
//                             ),
//                             Text(
//                               '~ ${distanceBtw.toStringAsFixed(0)} KMs',
//                               style: context.theme.textTheme.labelSmall,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 20),
//                     Expanded(
//                       child: InkWell(
//                         onTap: () {},
//                         // onTap: checkHasConversation.result.isLoading
//                         //     ? () {}
//                         //     : () {
//                         //         checkHasConversation.runMutation({
//                         //           'sender': user.id,
//                         //           'receiver': currentUser.value.id,
//                         //         });
//                         //       },
//                         child: Container(
//                           height: 45.sp,
//                           width: 50.sp,
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 0,
//                             // horizontal: checkHasConversation.result.isLoading
//                             //     ? 25.w
//                             //     : 0
//                           ),
//                           decoration: BoxDecoration(
//                             color: context.theme.indicatorColor,
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Icon(
//                             FlutterRemix.chat_3_fill,
//                             size: 22.sp,
//                             color: context.theme.iconTheme.color,
//                           ),
//                           // child: checkHasConversation.result.isLoading
//                           //     ? LoadingAnimationWidget.staggeredDotsWave(
//                           //         color: AppColors.primaryYellow,
//                           //         size: 20.w,
//                           //       )
//                           //     : Icon(
//                           //         FlutterRemix.chat_3_fill,
//                           //         size: 22.sp,
//                           //         color: context.theme.iconTheme.color,
//                           //       ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 20),
//                     Expanded(
//                       child: GestureDetector(
//                         onTap: () => Get.to(
//                           () => UserProfileScreen(
//                             user: user,
//                             followers: followersCount,
//                           ),
//                         ),
//                         child: Container(
//                           height: 45.sp,
//                           decoration: BoxDecoration(
//                             color: context.theme.indicatorColor,
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Icon(
//                             FlutterRemix.user_4_fill,
//                             size: 22.sp,
//                             color: context.theme.iconTheme.color,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               NavigateButton(
//                 title: user.name!.capitalizeFirst!,
//                 address: user.address!,
//                 latitude: user.location!.latitude!,
//                 longitude: user.location!.longitude!,
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
