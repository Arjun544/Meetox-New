import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:meetox/controllers/circles_controller.dart';
import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/models/circle_model.dart';
import 'package:meetox/services/circle_services.dart';

class CircleTile extends HookWidget {
  const CircleTile({
    required this.circle,
    required this.onTap,
    this.circlesController,
    super.key,
    this.isShowingOnMap = false,
  });
  final CircleModel circle;
  final bool isShowingOnMap;
  final CirclesController? circlesController;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final deleteCircleMutation = useMutation(
      CacheKeys.addCircle,
      (Map<String, dynamic> variables) async =>
          await CircleServices.deleteCircle(
        id: variables['id'],
      ),
      onData: (data, recoveryData) {
        circlesController!.onCircleDelete(context, data);
        Navigator.pop(context);
      },
      onError: (error, recoveryData) {
        logError(error.toString());
        showToast('Delete circle failed');
      },
    );

    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      child: Container(
        width: Get.width,
        height: 60.sp,
        margin: const EdgeInsets.only(bottom: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: context.theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListTile(
          minLeadingWidth: 0,
          splashColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            radius: 24.h,
            backgroundColor: context.theme.indicatorColor,
            foregroundImage: CachedNetworkImageProvider(
              circle.photo!.isEmpty ? profilePlaceHolder : circle.photo!,
            ),
          ),
          title: Text(
            circle.name == '' ? 'Unknown' : circle.name!.capitalizeFirst!,
            style: context.theme.textTheme.labelMedium,
          ),
          subtitle: Text(
            'Members: ${circle.circleMembers![0].count!}',
            style: context.theme.textTheme.labelSmall!.copyWith(
              fontSize: 10.sp,
            ),
          ),
          trailing: isShowingOnMap
              ? const SizedBox.shrink()
              : InkWell(
                  onTap: () => showCupertinoModalPopup(
                    context: context,
                    builder: (context) => CupertinoActionSheet(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            foregroundImage: CachedNetworkImageProvider(
                              circle.photo!.isEmpty
                                  ? profilePlaceHolder
                                  : circle.photo!,
                            ),
                          ),
                          SizedBox(width: 15.sp),
                          Text(
                            circle.name == ''
                                ? 'Unknown'
                                : circle.name!.capitalizeFirst!,
                            style: context.theme.textTheme.labelMedium,
                          ),
                        ],
                      ),
                      cancelButton: CupertinoActionSheetAction(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Cancel',
                          style: context.theme.textTheme.labelMedium,
                        ),
                      ),
                      actions: [
                        CupertinoActionSheetAction(
                          onPressed: () {},
                          child: Text(
                            'View profile',
                            style: context.theme.textTheme.labelMedium,
                          ),
                        ),
                        CupertinoActionSheetAction(
                          onPressed: () {},
                          child: Text(
                            'Chat',
                            style: context.theme.textTheme.labelMedium,
                          ),
                        ),
                        deleteCircleMutation.isMutating
                            ? Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Get.width * 0.42,
                                    vertical: 8.h),
                                child: LoadingAnimationWidget.staggeredDotsWave(
                                  color: AppColors.primaryYellow,
                                  size: 25.sp,
                                ),
                              )
                            : CupertinoActionSheetAction(
                                isDestructiveAction: true,
                                onPressed: () async =>
                                    await deleteCircleMutation.mutate({
                                  'id': circle.id!,
                                }),
                                child: Text(
                                  'Delete',
                                  style: context.theme.textTheme.labelMedium!
                                      .copyWith(
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Icon(
                      FlutterRemix.more_2_fill,
                      color: Colors.grey,
                      size: 18,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
