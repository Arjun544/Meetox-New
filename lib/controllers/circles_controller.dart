import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/models/circle_model.dart';
import 'package:meetox/services/circle_services.dart';

class CirclesController extends GetxController {
  final circlesPagingController =
      PagingController<int, CircleModel>(firstPageKey: 1);

  final RxString searchQuery = ''.obs;
  late Worker searchDebounce;

  @override
  void onInit() async {
    super.onInit();
    circlesPagingController.addPageRequestListener((page) async {
      await fetchCircles(page);
      searchDebounce = debounce(
        searchQuery,
        (value) {
          circlesPagingController.refresh();
        },
        time: const Duration(seconds: 2),
      );
    });
  }

  Future<void> fetchCircles(int pageKey) async {
    try {
      final newPage = await CircleServices.getCircles(
        limit: pageKey,
        query: searchQuery.value.isEmpty ? null : searchQuery.value,
      );

      final newItems = newPage;
      final hasNextPage = newPage.isEmpty;

      logSuccess(hasNextPage.toString());

      if (!hasNextPage) {
        circlesPagingController.appendLastPage(newItems);
      } else if (hasNextPage) {
        circlesPagingController.appendPage(newItems, pageKey + 1);
      }
    } catch (e) {
      logError(e.toString());
      circlesPagingController.error = e;
    }
  }

  @override
  void onClose() {
    // circlesPagingController.dispose();
    searchDebounce.dispose();
    super.onClose();
  }
}
