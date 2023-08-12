import 'package:cached_network_image/cached_network_image.dart';
import 'package:meetox/controllers/map_controller.dart';
import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/models/circle_model.dart';
import 'package:meetox/screens/circle_profile_screen/circle_profile_screen.dart';
import 'package:meetox/widgets/custom_sheet.dart';

import 'circle_details_sheet.dart';

class CustomCircleMarker extends StatelessWidget {
  const CustomCircleMarker({
    required this.circle,
    super.key,
  });
  final CircleModel circle;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        InkWell(
          onTap: () => Get.to(() => CircleProfileScreen(circle: circle)),
          child: Container(
            width: 40.sp,
            height: 40.sp,
            decoration: BoxDecoration(
              color: AppColors.customGrey,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                width: 3,
                color: Colors.lightBlue,
              ),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: CachedNetworkImageProvider(
                  circle.photo!.isEmpty ? profilePlaceHolder : circle.photo!,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -15,
          child: Icon(
            FlutterRemix.arrow_down_s_fill,
            size: 25.sp,
            color: Colors.lightBlue,
          ),
        ),
      ],
    );
  }
}
