import 'package:lottie/lottie.dart';
import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';

class PremiumButton extends StatelessWidget {
  const PremiumButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.95,
      height: Get.height * 0.1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryYellow,
            AppColors.primaryYellow.withOpacity(0.3),
            AppColors.primaryYellow,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primaryYellow,
        ),
      ),
      child: ListTile(
        minLeadingWidth: 0,
        contentPadding: const EdgeInsets.only(left: 20, right: 15, top: 5),
        leading: Transform.scale(
          scale: 1.5,
          child: Lottie.asset(
            AssetsManager.premiumIcon,
          ),
        ),
        title: Text('Meetox +', style: context.theme.textTheme.titleSmall),
        subtitle: Text(
          'Exclusive features',
          style: context.theme.textTheme.labelSmall,
        ),
        trailing: Icon(
          FlutterRemix.arrow_right_s_line,
          size: Get.height * 0.03,
          color: AppColors.customBlack,
        ),
      ),
    );
  }
}
