import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/services/circle_services.dart';

class JoinButton extends StatefulWidget {
  final String id;
  final bool isPrivate;
  final bool isAdmin;
  final int limit;
  final RxInt? members;

  const JoinButton({
    super.key,
    required this.id,
    this.members,
    required this.isAdmin,
    required this.isPrivate,
    required this.limit,
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
    await CircleServices.join(
      isLoading: isLoading,
      id: widget.id,
      onSuccess: (data) {
        if (data == true) {
          if (widget.members != null) {
            widget.members!.value += 1;
            isMember(true);
          }
          // Optimistic Updates after a successful follow
          // TODO: Add optimistic updates
        }
      },
    );
  }

  void handleLeave() async {
    await CircleServices.leave(
      isLoading: isLoading,
      id: widget.id,
      onSuccess: (data) {
        if (data == true) {
          if (widget.members != null) {
            widget.members!.value -= 1;
            isMember(false);
          }
          // Optimistic Updates after a successful follow
          // TODO: Add optimistic updates
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: !widget.isPrivate
          ? Obx(() => InkWell(
                onTap: () async {
                  if (isLoading.value) {
                  } else {
                    if (isMember.value) {
                      handleLeave();
                    } else {
                      if (widget.members!.value == widget.limit) {
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
                            ? widget.members!.value == widget.limit
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
                                color: context.theme.iconTheme.color!
                                    .withOpacity(
                                        widget.members!.value == widget.limit &&
                                                !isMember.value
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
            ),
    );
  }
}
