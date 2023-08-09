import 'package:meetox/controllers/circles_controller.dart';
import 'package:meetox/controllers/root_controller.dart';
import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/models/circle_model.dart';
import 'package:meetox/screens/add_circle_screen/add_circle_screen.dart';
import 'package:meetox/screens/circles_screen/components/circle_tile.dart';
import 'package:meetox/screens/root_screen.dart';
import 'package:meetox/widgets/custom_error_widget.dart';
import 'package:meetox/widgets/custom_field.dart';
import 'package:meetox/widgets/dialogues/upgrade_premium_dialogue.dart';
import 'package:meetox/widgets/loaders/circles_loader.dart';

import '../circle_profile_screen/circle_profile_screen.dart';

class CirclesScreen extends GetView<CirclesController> {
  const CirclesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CirclesController());
    final rootController = Get.find<RootController>();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Circles',
          style: context.theme.textTheme.labelMedium,
        ),
        leading: InkWell(
          onTap: Get.back,
          child: Icon(FlutterRemix.arrow_left_s_line, size: 25.sp),
        ),
        iconTheme: context.theme.appBarTheme.iconTheme,
        actions: [
          InkWell(
            onTap: () => controller.circlesPagingController.itemList != null &&
                    controller.circlesPagingController.itemList!.length ==
                        (currentUser.value.isPremium! ? 50 : 10)
                ? Get.generalDialog(
                    barrierDismissible: true,
                    barrierLabel: '',
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        FadeTransition(
                      opacity: animation,
                      child: const UpgradePremiumDialogue(
                        title: 'Cricles limit exceeded, Upgrade to Premium',
                      ),
                    ),
                  )
                : Get.to(() => const AddCircleScreen()),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: context.theme.indicatorColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(
                    FlutterRemix.add_fill,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 15.w),
        ],
      ),
      body: RefreshIndicator(
        backgroundColor: context.theme.scaffoldBackgroundColor,
        color: AppColors.primaryYellow,
        onRefresh: () async => controller.circlesPagingController.refresh(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              SizedBox(height: 15.h),
              SizedBox(
                height: 40.h,
                child: CustomField(
                  hintText: 'Search circles',
                  controller: TextEditingController(),
                  focusNode: FocusNode(),
                  isPasswordVisible: true.obs,
                  hasFocus: false.obs,
                  autoFocus: false,
                  isSearchField: true,
                  keyboardType: TextInputType.text,
                  prefixIcon: FlutterRemix.search_2_fill,
                  onChanged: (value) => controller.searchQuery(value),
                ),
              ),
              SizedBox(height: 15.sp),
              Expanded(
                child: PagedListView(
                  pagingController: controller.circlesPagingController,
                  builderDelegate: PagedChildBuilderDelegate<CircleModel>(
                    animateTransitions: true,
                    transitionDuration: const Duration(milliseconds: 300),
                    firstPageProgressIndicatorBuilder: (_) =>
                        const CirclesLoader(),
                    newPageProgressIndicatorBuilder: (_) =>
                        const CirclesLoader(),
                    firstPageErrorIndicatorBuilder: (_) => Center(
                      child: CustomErrorWidget(
                        image: AssetsManager.angryState,
                        text: 'Failed to fetch circles',
                        onPressed: controller.circlesPagingController.refresh,
                      ),
                    ),
                    newPageErrorIndicatorBuilder: (_) => Center(
                      child: CustomErrorWidget(
                        image: AssetsManager.angryState,
                        text: 'Failed to fetch circles',
                        onPressed: controller.circlesPagingController.refresh,
                      ),
                    ),
                    noItemsFoundIndicatorBuilder: (_) => CustomErrorWidget(
                      image: AssetsManager.sadState,
                      text: 'No circles found',
                      btnText: 'Find nearby',
                      onPressed: () {
                        rootController.selectedTab.value = 0;
                        Get.to(() => const RootScreen());
                      },
                    ),
                    itemBuilder: (context, item, index) => CircleTile(
                      circle: item,
                      circlesController: controller,
                      onTap: () => Get.to(
                        () => CircleProfileScreen(
                          circle: item,
                          allMembers: ValueNotifier(
                            item.circleMembers![0].count!,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
