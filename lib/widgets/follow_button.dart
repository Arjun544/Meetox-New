import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/models/profile_model.dart';
import 'package:meetox/models/user_model.dart';

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
          // Optimistic Updates after a successful follow
          final Query<List<UserModel>, dynamic> nearbyUsers =
              QueryClient.of(context)
                  .getQuery<List<UserModel>, dynamic>(CacheKeys.nearByUsers)!;

          final Query<List<UserModel>, dynamic> nearbyFollowers =
              QueryClient.of(context).getQuery<List<UserModel>, dynamic>(
                  CacheKeys.nearByFollowers)!;

          final Query<ProfileModel, dynamic> userProfile =
              QueryClient.of(context).getQuery<ProfileModel, dynamic>(
                  CacheKeys.userProfileDetails)!;

          userProfile.setData(ProfileModel(
            id: userProfile.data!.id,
            feeds: userProfile.data!.feeds,
            circles: userProfile.data!.circles,
            followers: followers!.value,
            followings: userProfile.data!.followings,
            crosspaths: userProfile.data!.crosspaths,
            questions: userProfile.data!.questions,
            createdAt: userProfile.data!.createdAt,
            dob: userProfile.data!.dob,
          ));

          nearbyFollowers.data!.add(
              nearbyUsers.data!.where((element) => element.id == id).first);
          nearbyFollowers.setData(nearbyFollowers.data!);

          nearbyUsers.data!.removeWhere((element) => element.id == id);
          nearbyUsers.setData(nearbyUsers.data!);

          final Query<bool, dynamic> checkIsFollowedQuery =
              QueryClient.of(context)
                  .getQuery<bool, dynamic>(CacheKeys.isFollowed)!;

          checkIsFollowedQuery.setData(true);
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

          // Optimistic Updates after a successful unfollow
          final Query<List<UserModel>, dynamic> nearbyUsers =
              QueryClient.of(context)
                  .getQuery<List<UserModel>, dynamic>(CacheKeys.nearByUsers)!;

          final Query<List<UserModel>, dynamic> nearbyFollowers =
              QueryClient.of(context).getQuery<List<UserModel>, dynamic>(
                  CacheKeys.nearByFollowers)!;

          final Query<ProfileModel, dynamic> userProfile =
              QueryClient.of(context).getQuery<ProfileModel, dynamic>(
                  CacheKeys.userProfileDetails)!;

          userProfile.setData(ProfileModel(
            id: userProfile.data!.id,
            feeds: userProfile.data!.feeds,
            circles: userProfile.data!.circles,
            followers: userProfile.data!.followers,
            followings: userProfile.data!.followings! - 1,
            crosspaths: userProfile.data!.crosspaths,
            questions: userProfile.data!.questions,
            createdAt: userProfile.data!.createdAt,
            dob: userProfile.data!.dob,
          ));

          nearbyUsers.data!.add(
              nearbyFollowers.data!.where((element) => element.id == id).first);
          nearbyUsers.setData(nearbyUsers.data!);

          nearbyFollowers.data!.removeWhere((element) => element.id == id);
          nearbyFollowers.setData(nearbyUsers.data!);

          final Query<bool, dynamic> checkIsFollowedQuery =
              QueryClient.of(context)
                  .getQuery<bool, dynamic>(CacheKeys.isFollowed)!;

          checkIsFollowedQuery.setData(false);
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
