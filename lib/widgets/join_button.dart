import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/services/circle_services.dart';

class JoinButton extends StatefulWidget {
  final String id;
  final bool isPrivate;
  final bool isAdmin;
  final bool hasLimitReached;
  final void Function() onJoin;
  final void Function() onJoinError;
  final void Function() onLeave;
  final void Function() onLeaveError;

  const JoinButton({
    super.key,
    required this.id,
    required this.isAdmin,
    required this.isPrivate,
    required this.hasLimitReached,
    required this.onJoin,
    required this.onJoinError,
    required this.onLeave,
    required this.onLeaveError,
  });

  @override
  State<JoinButton> createState() => _JoinButtonState();
}

class _JoinButtonState extends State<JoinButton> {
  final RxBool isLoading = false.obs;
  final RxBool isMember = false.obs;

  @override
  void initState() {
    checkIsFollowed();
    super.initState();
  }

  void checkIsFollowed() async {
    isMember.value = await CircleServices.isMember(
      id: widget.id,
      isLoading: isLoading,
    );
  }

  void handleJoin() async {
    isMember(true);
    widget.onJoin();
    await CircleServices.join(
      id: widget.id,
      onError: () {
        isMember(false);
        widget.onJoinError();
      },
    );
  }

  void handleLeave() async {
    isMember(false);
    widget.onLeave();
    await CircleServices.leave(
      id: widget.id,
      onError: () {
        isMember(true);
        widget.onLeaveError();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return !widget.isPrivate
        ? Obx(() => InkWell(
              onTap: () async {
                if (isLoading.value) {
                } else {
                  if (isMember.value) {
                    handleLeave();
                  } else {
                    if (widget.hasLimitReached) {
                      showToast('Circle reached members limit');
                    } else {
                      handleJoin();
                    }
                  }
                }
              },
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: isLoading.value
                      ? AppColors.primaryYellow
                      : isMember.value == false
                          ? widget.hasLimitReached
                              ? context.theme.indicatorColor
                              : AppColors.primaryYellow
                          : isMember.value
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
                              isMember.value
                                  ? FlutterRemix.logout_circle_fill
                                  : FlutterRemix.login_circle_fill,
                              size: 16.sp,
                              color: context.theme.iconTheme.color!.withOpacity(
                                  widget.hasLimitReached && !isMember.value
                                      ? 0.5
                                      : 1),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              isMember.value ? 'Leave' : 'Join',
                              style: context.theme.textTheme.labelSmall,
                            ),
                          ],
                        ),
                ),
              ),
            ))
        : InkWell(
            onTap: () => showToast('Circle is private'),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: context.theme.indicatorColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 12.sp, vertical: 10.sp),
                child: Icon(
                  FlutterRemix.door_lock_fill,
                  size: 16.sp,
                  color: context.theme.iconTheme.color,
                ),
              ),
            ),
          );
  }
}
