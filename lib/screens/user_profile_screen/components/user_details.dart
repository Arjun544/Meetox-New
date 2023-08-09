import 'package:cached_network_image/cached_network_image.dart';
import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/helpers/get_social.dart';
import 'package:meetox/helpers/launch_url.dart';
import 'package:meetox/models/user_model.dart';
import 'package:meetox/screens/followers_screen/followers_screen.dart';
import 'package:meetox/services/follow_services.dart';
import 'package:meetox/services/user_services.dart';
import 'package:meetox/widgets/custom_tabbar.dart';
import 'package:meetox/widgets/follow_button.dart';
import 'package:meetox/widgets/loaders/socials_loaders.dart';

class UserDetails extends HookWidget {
  final UserModel user;
  final TabController tabController;
  final int followers;

  const UserDetails(this.user, this.tabController, this.followers, {super.key});

  @override
  Widget build(BuildContext context) {
    final totalFollowers = useState(followers);
    final followersCount = useQuery<int, dynamic>(
      CacheKeys.followersCount,
      () async => await FollowServices.getFollowersCount(
        id: user.id!,
      ),
      onData: (value) => totalFollowers.value = value,
    );

    final followingsCount = useQuery<int, dynamic>(
      CacheKeys.followingsCount,
      () async => await FollowServices.getFollowingsCount(
        id: user.id!,
      ),
    );

    final getSocials = useQuery<List<Social>, dynamic>(
      CacheKeys.userSocials,
      () async => await UserServices.getSocials(),
    );

    return SliverAppBar(
      elevation: 0.1,
      expandedHeight: Get.height * 0.37,
      collapsedHeight: 100,
      pinned: true,
      title: Text(
        user.name!.capitalizeFirst!,
        style: context.theme.textTheme.labelMedium,
      ),
      bottom: PreferredSize(
        preferredSize: Size(Get.width, 0),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: CustomTabbar(
            controller: tabController,
            tabs: const [
              Text('Info'),
              Text('Feeds'),
            ],
            onTap: (int value) {},
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Padding(
          padding: EdgeInsets.only(top: Get.height * 0.15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: Get.height * 0.09,
                    width: Get.width * 0.18,
                    decoration: BoxDecoration(
                      color: context.theme.indicatorColor,
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(
                          user.photo!,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (!followersCount.isLoading &&
                          followersCount.data != 0) {
                        Get.to(() => FollowersScreen(user, false));
                      }
                    },
                    child: Column(
                      children: [
                        Text(
                          totalFollowers.value.toString(),
                          style: context.theme.textTheme.labelMedium,
                        ),
                        Text(
                          'Followers',
                          style: context.theme.textTheme.labelSmall!
                              .copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (!followingsCount.isLoading &&
                          followingsCount.data != 0) {
                        Get.to(() => FollowersScreen(user, true));
                      }
                    },
                    child: Column(
                      children: [
                        Text(
                          followingsCount.isLoading
                              ? user.followings.toString()
                              : followingsCount.data.toString(),
                          style: context.theme.textTheme.labelMedium,
                        ),
                        Text(
                          'Followings',
                          style: context.theme.textTheme.labelSmall!
                              .copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.h),
              Row(
                mainAxisAlignment:
                    !getSocials.isLoading && getSocials.data!.isEmpty
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.spaceEvenly,
                children: [
                  FollowButton(
                    id: user.id!,
                    followers: totalFollowers,
                  ),
                  getSocials.isLoading
                      ? const SocialsLoaders()
                      : getSocials.data!.isEmpty
                          ? const SizedBox.shrink()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: getSocials.data!
                                  .map<Widget>(
                                    (social) => InkWell(
                                      onTap: () => appLaunchUrl(social.url!),
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          color: context.theme.indicatorColor,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(
                                            getSocial(social.type!),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
