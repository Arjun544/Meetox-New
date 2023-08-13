// ignore_for_file: invalid_use_of_protected_member

import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/services/follow_services.dart';

class MyFollowButton extends StatefulWidget {
  final String followingId;
  final void Function() onFollow;
  final void Function() onFollowError;
  final void Function() onUnFollow;
  final void Function() onUnFollowError;

  const MyFollowButton({
    super.key,
    required this.followingId,
    required this.onFollow,
    required this.onFollowError,
    required this.onUnFollow,
    required this.onUnFollowError,
  });

  @override
  State<MyFollowButton> createState() => _MyFollowButtonState();
}

class _MyFollowButtonState extends State<MyFollowButton> {
  final RxBool isLoading = false.obs;
  final RxBool isAlreadyFollowed = false.obs;
  final RxBool isFollowed = false.obs;

  @override
  void initState() {
    checkIsFollowed();
    super.initState();
  }

  void checkIsFollowed() async {
    isAlreadyFollowed.value = await FollowServices.isFollowed(
      followerId: widget.followingId,
      followingId: currentUser.value.id!,
      isLoading: isLoading,
    );
  }

  void handleFollow() async {
    isFollowed(true);
    widget.onFollow();
    await FollowServices.followUser(
      followerId: widget.followingId,
      followingId: currentUser.value.id!,
      onError: () {
        isFollowed(false);
        widget.onFollowError();
        showToast('Follow failed');
      },
    );
  }

  void handleUnFollow() async {
    isFollowed(false);
    widget.onUnFollow();
    await FollowServices.unFollowUser(
      followerId: widget.followingId,
      followingId: currentUser.value.id!,
      onError: () {
        isFollowed(true);
        widget.onUnFollowError();
        showToast('Unfollow failed');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => isLoading.value || isAlreadyFollowed.value == true
          ? const SizedBox.shrink()
          : InkWell(
              onTap: isLoading.value
                  ? () {}
                  : () async {
                      if (isFollowed.value == true) {
                        handleUnFollow();
                      } else {
                        handleFollow();
                      }
                    },
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.sp,
                  vertical: 6.sp,
                ),
                child: Text(
                  isFollowed.value == true ? 'Unfollow' : 'Follow',
                  style: context.theme.textTheme.labelSmall!.copyWith(
                    color: isFollowed.value == true ? Colors.red : Colors.blue,
                  ),
                ),
              ),
            ),
    );
  }
}
