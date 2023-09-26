import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:meetox/models/message_model.dart';

import '../../../core/imports/core_imports.dart';
import '../../../widgets/mini_map.dart';

class LocationBubble extends StatelessWidget {
  final MessageModel msg;

  const LocationBubble({super.key, required this.msg});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final availableMaps = await MapLauncher.installedMaps;
        await availableMaps.first.showMarker(
          coords: Coords(msg.latitude!, msg.longitude!),
          title: msg.content!,
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: SizedBox(
              height: 130.sp,
              child: IgnorePointer(
                child: MiniMap(
                  latitude: msg.latitude!,
                  longitude: msg.longitude!,
                  image: ''.obs,
                  color: AppColors.primaryYellow,
                ),
              ),
            ),
          ),
          SizedBox(height: msg.content!.isNotEmpty ? 8 : 0),
          msg.content!.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        FlutterRemix.map_pin_2_fill,
                        size: 16,
                        color: AppColors.customBlack,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        msg.content!,
                        style: context.theme.textTheme.labelSmall!
                            .copyWith(color: AppColors.customBlack),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
