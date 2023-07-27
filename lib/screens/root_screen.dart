import '../core/imports/core_imports.dart';
import '../widgets/custom_button.dart';

class RootScreen extends StatelessWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          supabase.auth.currentUser!.userMetadata!['name'],
        ),
      ),
      body: Center(
        child: CustomButton(
          width: Get.width * 0.5,
          text: 'Sign Out',
          onPressed: () async {
            await supabase.auth.signOut();
          },
        ),
      ),
    );
  }
}
