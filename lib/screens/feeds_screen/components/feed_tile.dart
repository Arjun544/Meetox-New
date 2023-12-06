import 'package:cached_network_image/cached_network_image.dart';
import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/models/feed_model.dart';
import 'package:meetox/widgets/user_initials.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'feed_actions.dart';
import 'feed_comments.dart';

class FeedTile extends StatelessWidget {
  final FeedModel feed;

  const FeedTile({super.key, required this.feed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    feed.admin!.photo == null
                        ? UserInititals(name: feed.admin!.name ?? 'Unknown')
                        : Container(
                            height: 30.h,
                            width: 40.w,
                            decoration: BoxDecoration(
                              color: context.theme.primaryColor,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: context.isDarkMode
                                      ? Colors.black
                                      : Colors.grey[400]!,
                                  blurRadius: 0.3,
                                ),
                              ],
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: CachedNetworkImageProvider(
                                  feed.admin!.photo!,
                                ),
                              ),
                            ),
                          ),
                    Expanded(
                      child: Align(
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 4.h),
                          width: 2.w,
                          decoration: BoxDecoration(
                            color: context.theme.indicatorColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 20.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            feed.admin!.name!.capitalizeFirst!,
                            style:
                                context.theme.textTheme.labelMedium!.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                timeago.format(
                                  feed.createdAt!,
                                  locale: 'en',
                                  allowFromNow: true,
                                ),
                                style: context.theme.textTheme.labelSmall!
                                    .copyWith(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 10.sp,
                                  color: context
                                      .theme.textTheme.labelSmall!.color!
                                      .withOpacity(0.5),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        feed.content!.capitalizeFirst!,
                        style: context.theme.textTheme.labelSmall,
                      ),
                      SizedBox(height: 10.h),
                      const FeedActions(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          const FeedComments(),
        ],
      ),
    );
  }
}
