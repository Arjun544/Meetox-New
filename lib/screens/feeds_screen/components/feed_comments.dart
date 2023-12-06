import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';

class FeedComments extends StatelessWidget {
  const FeedComments({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: SizedBox(
            width: 60.w,
            height: 20.h,
            child: Stack(
              alignment: Alignment.center,
              children: List.generate(
                3,
                (index) => Positioned(
                  left: index * 10,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: context.theme.scaffoldBackgroundColor,
                        width: 2,
                      ),
                      shape: BoxShape.circle,
                      color: context.theme.primaryColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: Get.width * 0.38,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '2 comments',
                style: context.theme.textTheme.labelSmall!.copyWith(
                  color: context.theme.textTheme.labelSmall!.color!
                      .withOpacity(0.4),
                ),
              ),
              Text(
                '•',
                style: context.theme.textTheme.labelSmall!.copyWith(
                  color: context.theme.textTheme.labelSmall!.color!
                      .withOpacity(0.4),
                ),
              ),
              Text(
                '14 likes',
                style: context.theme.textTheme.labelSmall!.copyWith(
                  color: context.theme.textTheme.labelSmall!.color!
                      .withOpacity(0.4),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
