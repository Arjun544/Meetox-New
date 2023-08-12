// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:meetox/controllers/map_controller.dart';
// import 'package:meetox/core/imports/core_imports.dart';
// import 'package:meetox/core/imports/packages_imports.dart';
// import 'package:meetox/helpers/get_distance.dart';
// import 'package:meetox/models/circle_model.dart';
// import 'package:meetox/screens/circle_profile_screen/circle_profile_screen.dart';
// import 'package:meetox/widgets/join_button.dart';
// import 'package:meetox/widgets/navigate_button.dart';

// class CircleDetailsSheet extends HookWidget {
//   final CircleModel circle;
//   final Rx<CircleModel> tappedCircle;

//   const CircleDetailsSheet(this.circle, this.tappedCircle, {super.key});

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.find<MapScreenController>();
//     final members = useState(circle.circleMembers![0].count!);

//     final double currentLatitude =
//         controller.rootController.currentPosition.value.latitude;
//     final double currentLongitude =
//         controller.rootController.currentPosition.value.longitude;
//     final double circleLatitude = circle.location!.latitude!;
//     final double circleLongitude = circle.location!.longitude!;

//     final double distanceBtw = getDistance(
//       currentLatitude,
//       currentLongitude,
//       circleLatitude,
//       circleLongitude,
//     );

//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       controller.animatedMapMove(
//         LatLng(
//           circleLatitude,
//           circleLongitude,
//         ),
//         14,
//       );
//     });
//     return Stack(
//       children: [
//         GestureDetector(
//           onTap: () {
//             controller.isFiltersVisible.value = true;
//             tappedCircle.value = CircleModel();
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
//               ListTile(
//                   dense: true,
//                   leading: ClipRRect(
//                     borderRadius: BorderRadius.circular(12),
//                     child: CachedNetworkImage(
//                       imageUrl: circle.photo!.isEmpty
//                           ? profilePlaceHolder
//                           : circle.photo!,
//                       // height: 170.sp,
//                       width: 50.sp,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                   title: Text(
//                     circle.name!.capitalizeFirst!,
//                     style: context.theme.textTheme.labelMedium,
//                   ),
//                   subtitle: Text(
//                     circle.address!.capitalizeFirst!,
//                     style: context.theme.textTheme.labelSmall!.copyWith(
//                       color: Colors.grey,
//                     ),
//                   ),
//                   trailing: JoinButton(
//                     id: circle.id!,
//                     isPrivate: circle.isPrivate!,
//                     limit: circle.limit!,
//                     members: members,
//                     isAdmin: false,
//                   )),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Column(
//                     children: [
//                       Text(
//                         members.value.toString(),
//                         style: context.theme.textTheme.labelMedium,
//                       ),
//                       Text(
//                         'Members',
//                         style: context.theme.textTheme.labelSmall!
//                             .copyWith(color: Colors.grey),
//                       ),
//                     ],
//                   ),
//                   Column(
//                     children: [
//                       Text(
//                         circle.limit.toString(),
//                         style: context.theme.textTheme.labelMedium,
//                       ),
//                       Text(
//                         'Limit',
//                         style: context.theme.textTheme.labelSmall!
//                             .copyWith(color: Colors.grey),
//                       ),
//                     ],
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
//                       child: Container(
//                         height: 45.sp,
//                         alignment: Alignment.center,
//                         decoration: BoxDecoration(
//                           color: context.theme.indicatorColor,
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Text(
//                           circle.isPrivate! ? 'Private' : 'Public',
//                           style: context.theme.textTheme.labelSmall,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 20),
//                     Expanded(
//                       child: InkWell(
//                         onTap: () => Get.to(
//                           () => CircleProfileScreen(
//                             circle: circle,
//                             allMembers: members,
//                           ),
//                         ),
//                         child: Container(
//                           height: 45.sp,
//                           decoration: BoxDecoration(
//                             color: context.theme.indicatorColor,
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Icon(
//                             FlutterRemix.profile_fill,
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
//                 title: circle.name!.capitalizeFirst!,
//                 address: circle.address!,
//                 latitude: circle.location!.latitude!,
//                 longitude: circle.location!.longitude!,
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
