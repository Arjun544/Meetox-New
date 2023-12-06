import '../../../core/imports/core_imports.dart';

class BuildTitle extends StatelessWidget {
  final String title;

  const BuildTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: context.theme.textTheme.titleMedium,
    );
  }
}
