import 'package:meetox/controllers/feeds_controller.dart';
import 'package:meetox/widgets/top_bar.dart';

import '../../core/imports/core_imports.dart';

class FeedScreen extends GetView<FeedsController> {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TopBar(
            isPrecise: false.obs,
          ),
        ],
      ),
    );
  }
}
