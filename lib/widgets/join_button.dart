import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/services/circle_services.dart';

class JoinButton extends HookWidget {
  final String id;
  final bool isPrivate;
  final bool isAdmin;
  final int limit;
  final ValueNotifier<int>? members;

  const JoinButton({
    super.key,
    required this.id,
    this.members,
    required this.isAdmin,
    required this.isPrivate,
    required this.limit,
  });

  @override
  Widget build(BuildContext context) {
    final isLoading = useState(false);

    final checkIsMember = useQuery<bool, dynamic>(
      CacheKeys.isMember,
      () async => await CircleServices.isMember(
        id: id,
      ),
      onError: (value) => logError(value.toString()),
    );

    final joinCircle =
        useMutation<bool, dynamic, Map<String, dynamic>, dynamic>(
      CacheKeys.joinCircle,
      (varibles) async => await CircleServices.join(
        id: varibles['id'],
        isLoading: isLoading,
      ),
      onData: (data, _) async {
        if (data == true) {
          if (members != null) {
            members!.value += 1;
          }
          // Optimistic Updates after a successful adding member
          final Query<bool, dynamic> checkIsMemberQuery =
              QueryClient.of(context)
                  .getQuery<bool, dynamic>(CacheKeys.isMember)!;

          checkIsMemberQuery.setData(true);
        }
      },
    );

    final leaveCircle =
        useMutation<bool, dynamic, Map<String, dynamic>, dynamic>(
      CacheKeys.unFollowUser,
      (varibles) async => await CircleServices.leave(
        id: varibles['id'],
        isLoading: isLoading,
      ),
      onData: (data, _) async {
        if (data == true) {
          if (members != null) {
            members!.value -= 1;
          }

          // Optimistic Updates after a successful adding member
          final Query<bool, dynamic> checkIsMemberQuery =
              QueryClient.of(context)
                  .getQuery<bool, dynamic>(CacheKeys.isMember)!;

          checkIsMemberQuery.setData(false);
        }
      },
    );
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: isAdmin && !isPrivate
          ? InkWell(
              onTap: () async {
                if (checkIsMember.isLoading || isLoading.value) {
                } else {
                  if (checkIsMember.data!) {
                    leaveCircle.mutate({
                      "id": id,
                    });
                  } else {
                    if (members!.value == limit) {
                      showToast('Circle reached members limit');
                    } else {
                      joinCircle.mutate({
                        "id": id,
                      });
                    }
                  }
                }
              },
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: checkIsMember.isLoading
                      ? AppColors.primaryYellow
                      : checkIsMember.data == false
                          ? members!.value == limit
                              ? context.theme.indicatorColor
                              : AppColors.primaryYellow
                          : checkIsMember.data!
                              ? Colors.redAccent
                              : AppColors.primaryYellow,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.sp,
                    vertical: 6.sp,
                  ),
                  child: checkIsMember.isLoading || isLoading.value
                      ? LoadingAnimationWidget.staggeredDotsWave(
                          color: AppColors.customBlack,
                          size: 20.sp,
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              checkIsMember.data!
                                  ? FlutterRemix.logout_circle_fill
                                  : FlutterRemix.login_circle_fill,
                              size: 16.sp,
                              color: context.theme.iconTheme.color!.withOpacity(
                                  members!.value == limit &&
                                          !checkIsMember.data!
                                      ? 0.5
                                      : 1),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              checkIsMember.data! ? 'Leave' : 'Join',
                              style: context.theme.textTheme.labelSmall,
                            ),
                          ],
                        ),
                ),
              ),
            )
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
