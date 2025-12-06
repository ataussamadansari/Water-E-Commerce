import 'package:admin/app/core/utils/helpers.dart';
import 'package:admin/app/data/models/regions/region_model.dart';
import 'package:admin/app/data/repositories/regions/region_repository.dart';
import 'package:admin/app/routes/app_routes.dart';
import 'package:get/get.dart';

class RegionsScreenController extends GetxController {
  final RegionRepository _regionRepo = RegionRepository();

  final RxBool isLoading = false.obs;
  final RxList<Region> regions = <Region>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchRegions();
  }

  Future<void> fetchRegions() async {
    isLoading.value = true;
    try {
      final response = await _regionRepo.getRegions();
      if (response.success && response.data != null) {
        regions.assignAll(response.data!.data!);
      } else {
        AppHelpers.showSnackBar(
          title: "Error",
          message: response.message,
          isError: true,
        );
      }
    } catch (e) {
      AppHelpers.showSnackBar(
        title: "Error",
        message: e.toString(),
        isError: true,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // --- DELETE REGION LOGIC (Cleaned) ---
  Future<void> deleteRegion(int regionId) async {
    // Dialog hata diya, kyunki wo View (Dismissible) me handle ho raha hai

    // 1. Show global loading (optional, but good for UX)
    // isLoading.value = true; // Hata sakte hain agar slide animation smooth chahiye

    // 2. Call Repository
    final response = await _regionRepo.deleteRegion(regionId);

    // 3. Handle Response
    if (response.success) {
      // Remove locally to update UI instantly
      regions.removeWhere((element) => element.id == regionId);

      AppHelpers.showSnackBar(
        title: "Success",
        message: response.message,
      );
    } else {
      // Agar delete fail hua, to list refresh karo taaki item wapas aa jaye
      await fetchRegions();

      AppHelpers.showSnackBar(
        title: "Error",
        message: response.message,
        isError: true,
      );
    }

    isLoading.value = false;
  }


  // This function is already correct.
  Future<void> goToAddRegion() async {
    // `await` is key. It pauses execution here until Get.back(result: ...) is called.
    final result = await Get.toNamed(Routes.addRegions);

    // When the AddRegionScreen returns `true`, this code will execute.
    if (result == true) {
      fetchRegions(); // This re-fetches the list, updating the UI.
    }
  }

  // This function is also correct.
  Future<void> gotoEditRegion(Region region) async {
    final result = await Get.toNamed(Routes.addRegions, arguments: region);
    if (result == true) {
      fetchRegions(); // This re-fetches the list, updating the UI.
    }
  }

  Future<void> onRefresh() async {
    await fetchRegions();
  }
}
