import 'package:lottie/lottie.dart';
import 'package:meetox/core/enums.dart';
import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/widgets/close_button.dart';
import 'package:meetox/widgets/custom_button.dart';

class UpgradePremiumDialogue extends StatelessWidget {
  final String title;

  const UpgradePremiumDialogue({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final Rx<PremiumPlans> selectedPlan = PremiumPlans.monthly.obs;

    return Material(
      color: Colors.transparent,
      child: Container(
        margin:
            EdgeInsets.symmetric(vertical: Get.height * 0.07, horizontal: 15.w),
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              AppColors.primaryYellow,
              AppColors.primaryYellow,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: CustomCloseButton(
                    onTap: () => Get.back(),
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  title,
                  style: context.theme.textTheme.labelMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Transform.scale(
              scale: 1.5,
              child: Lottie.asset(
                AssetsManager.premiumIcon,
              ),
            ),
            Column(
              children: [
                Text(
                  'Choose your plan',
                  style: context.theme.textTheme.titleSmall,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 15.h),
                buildTile(
                  context: context,
                  type: PremiumPlans.monthly,
                  selectedPlan: selectedPlan,
                  title: '\$4.99 / Month',
                  subtitle: 'Get 7 days free trial',
                ),
                SizedBox(height: 10.h),
                buildTile(
                  context: context,
                  type: PremiumPlans.yearly,
                  selectedPlan: selectedPlan,
                  title: '\$48 / Year',
                  subtitle: '\$4 / Month. Billed annually',
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  'Learn more',
                  style: context.theme.textTheme.labelMedium!.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(height: 20.h),
                CustomButton(
                  width: Get.width,
                  text: 'Start trial',
                  onPressed: () {},
                ),
                SizedBox(height: 10.h),
                Text(
                  'Cancel anytime',
                  style: context.theme.textTheme.labelSmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Obx buildTile({
    required BuildContext context,
    required String title,
    required String subtitle,
    required PremiumPlans type,
    required Rx<PremiumPlans> selectedPlan,
  }) {
    return Obx(
      () => GestureDetector(
        onTap: () => selectedPlan.value = type,
        child: AnimatedContainer(
          width: double.infinity,
          height: Get.height * 0.1,
          alignment: Alignment.center,
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: selectedPlan.value == type
                ? Colors.white
                : AppColors.primaryYellow,
            border: selectedPlan.value == type
                ? null
                : Border.all(
                    color: Colors.white,
                  ),
          ),
          child: ListTile(
            titleAlignment: ListTileTitleAlignment.center,
            leading: Icon(
              selectedPlan.value == type
                  ? IconsaxBold.tick_circle
                  : FlutterRemix.checkbox_blank_circle_line,
              color: selectedPlan.value == type
                  ? AppColors.customBlack
                  : Colors.white,
              size: 22.h,
            ),
            title: Text(
              title,
              style: context.theme.textTheme.labelLarge!.copyWith(
                fontWeight: FontWeight.w700,
                color: selectedPlan.value == type
                    ? AppColors.customBlack
                    : Colors.white,
              ),
            ),
            subtitle: Text(
              subtitle,
              style: context.theme.textTheme.labelSmall!.copyWith(
                color: selectedPlan.value == type
                    ? AppColors.customBlack
                    : Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
