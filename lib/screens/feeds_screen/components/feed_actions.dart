import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';

class FeedActions extends StatelessWidget {
  const FeedActions({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: Get.width * 0.3,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(IconsaxOutline.heart),
          const Icon(IconsaxOutline.messages_3),
          Transform.rotate(
            angle: -pi / 4,
            child: const Icon(IconsaxOutline.send_1),
          ),
        ],
      ),
    );
  }
}


