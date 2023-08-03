import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';

import '../services/follow_services.dart';

class FollowButton extends HookWidget {
  final String id;
  final ValueNotifier<int>? followers;

  const FollowButton({super.key, required this.id, this.followers});

  @override
  Widget build(BuildContext context) {
    final isFollowLoading = useState(false);

    final checkIsFollowed = useQuery<bool, dynamic>(
      CacheKeys.isFollowed,
      () async => await FollowServices.isFollowed(targetUserId: id),
      onError: (value) => logError(value.toString()),
    );
    final followUser =
        useMutation<bool, dynamic, Map<String, dynamic>, dynamic>(
      CacheKeys.followUser,
      (varibles) async => await FollowServices.followUser(
        targetUserId: varibles['id'],
        isLoading: isFollowLoading,
      ),
      onData: (data, _) async {
        if (data == true) {
          if (followers != null) {
            followers!.value += 1;
          }
          await checkIsFollowed.refresh();
        }
      },
    );
    final unFollowUser =
        useMutation<bool, dynamic, Map<String, dynamic>, dynamic>(
      CacheKeys.unFollowUser,
      (varibles) async => await FollowServices.unFollowUser(
        targetUserId: varibles['id'],
        isLoading: isFollowLoading,
      ),
      onData: (data, _) async {
        if (data == true) {
          if (followers != null) {
            followers!.value -= 1;
          }
          await checkIsFollowed.refresh();
        }
      },
    );
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: InkWell(
        onTap: checkIsFollowed.isLoading || isFollowLoading.value
            ? () {}
            : () async {
                if (checkIsFollowed.data == true) {
                  unFollowUser.mutate({
                    "id": id,
                  });
                } else {
                  followUser.mutate({
                    "id": id,
                  });
                }
              },
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: checkIsFollowed.isLoading
                ? AppColors.customGrey
                : checkIsFollowed.data == true
                    ? Colors.redAccent
                    : AppColors.primaryYellow,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 12.sp,
              vertical: 6.sp,
            ),
            child: checkIsFollowed.isLoading || isFollowLoading.value
                ? LoadingAnimationWidget.staggeredDotsWave(
                    color: AppColors.customBlack,
                    size: 20.sp,
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        checkIsFollowed.data == true
                            ? FlutterRemix.user_unfollow_fill
                            : FlutterRemix.user_add_fill,
                        size: 16.sp,
                        color: context.theme.iconTheme.color,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        checkIsFollowed.data == true ? 'Unfollow' : 'Follow',
                        style: context.theme.textTheme.labelSmall,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
