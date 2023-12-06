import '../../../core/imports/core_imports.dart';

class BuildSubTitle extends StatelessWidget {
  final String subTitle;

  const BuildSubTitle({super.key, required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Text(
      subTitle,
      style: context.theme.textTheme.labelLarge!.copyWith(
        color: context.theme.indicatorColor,
      ),
    );
  }
}
