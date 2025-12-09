import 'package:get/get.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/models/products/product_model.dart';
import '../../../data/services/product/product_service.dart';

class ManageStockScreenController extends GetxController {
  final ProductService productService = Get.find<ProductService>();

  RxList<Product> get masterList => productService.products;
  RxList<Product> filteredProducts = <Product>[].obs;

  // Track loading state for specific product updates (optional UX enhancement)
  final RxMap<int, bool> updatingItems = <int, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();

    // Whenever master list changes, reset filtered list
    ever(productService.products, (_) {
      filteredProducts.assignAll(masterList);
    });

    // Initial load
    filteredProducts.assignAll(masterList);
  }

  void search(String query) {
    if (query.isEmpty) {
      filteredProducts.assignAll(masterList);
    } else {
      filteredProducts.assignAll(masterList.where((p) =>
          p.name!.toLowerCase().contains(query.toLowerCase())
      ));
    }
  }

  Future<void> updateStockAndStatus(int productId, String stock, bool isActive) async {
    // 1. Validate
    if (stock.isEmpty) {
      AppHelpers.showSnackBar(title: "Error", message: "Stock cannot be empty", isError: true);
      return;
    }

    // 2. Set loading for this specific item
    updatingItems[productId] = true;

    // 3. Prepare Data
    final data = {
      "stock_qty": stock,
      "is_active": isActive,
    };

    // 4. Call Service
    final success = await productService.updateProductFromApi(productId, data);

    // 5. Cleanup
    updatingItems[productId] = false;

    if (success) {
      AppHelpers.showSnackBar(title: "Success", message: "Stock updated successfully", isError: false);
    } else {
      AppHelpers.showSnackBar(title: "Error", message: "Failed to update", isError: true);
    }
  }
}
