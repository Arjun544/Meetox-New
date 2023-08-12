// ignore_for_file: invalid_use_of_protected_member

import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';

import '../services/follow_services.dart';

class FollowButton extends StatefulWidget {
  final String id;
  final void Function(bool) onFollow;
  final void Function(bool) onUnFollow;

  const FollowButton({
    super.key,
    required this.id,
    required this.onFollow,
    required this.onUnFollow,
  });

  @override
  State<FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  final RxBool isLoading = false.obs;
  final RxBool isFollowed = false.obs;

  @override
  void initState() {
    checkIsFollowed();
    super.initState();
  }

  void checkIsFollowed() async {
    isFollowed.value = await FollowServices.isFollowed(
      targetUserId: widget.id,
      isLoading: isLoading,
    );
  }

  void handleFollow() async {
    await FollowServices.followUser(
      isLoading: isLoading,
      targetUserId: widget.id,
      onSuccess: (data) {
        isFollowed(true);
        widget.onFollow(data);
      },
    );
  }

  void handleUnFollow() async {
    await FollowServices.unFollowUser(
      isLoading: isLoading,
      targetUserId: widget.id,
      onSuccess: (data) {
        isFollowed(false);
        widget.onUnFollow(data);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => InkWell(
        onTap: isLoading.value
            ? () {}
            : () async {
                if (isFollowed.value == true) {
                  handleUnFollow();
                } else {
                  handleFollow();
                }
              },
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: isLoading.value
                ? AppColors.customGrey
                : isFollowed.value == true
                    ? Colors.redAccent
                    : AppColors.primaryYellow,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 12.sp,
              vertical: 6.sp,
            ),
            child: isLoading.value
                ? LoadingAnimationWidget.staggeredDotsWave(
                    color: AppColors.customBlack,
                    size: 20.sp,
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isFollowed.value == true
                            ? FlutterRemix.user_unfollow_fill
                            : FlutterRemix.user_add_fill,
                        size: 16.sp,
                        color: context.theme.iconTheme.color,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isFollowed.value == true ? 'Unfollow' : 'Follow',
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
