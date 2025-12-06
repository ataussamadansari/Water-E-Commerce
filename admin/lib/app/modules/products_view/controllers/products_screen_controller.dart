import 'package:get/get.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/models/products/product_model.dart';
import '../../../data/services/product/product_service.dart';
import '../../../routes/app_routes.dart';

class ProductsScreenController extends GetxController {
  final ProductService productService = Get.find<ProductService>();

  RxList<Product> get masterList => productService.products;
  RxList<Product> filteredProducts = <Product>[].obs;

  @override
  void onInit() {
    super.onInit();

    /// Whenever products change in ProductService → update filtered list.
    ever(productService.products, (_) {
      filteredProducts.assignAll(masterList);
    });

    /// Initialize first view
    filteredProducts.assignAll(masterList);
  }

  // ------------------------------------------------------
  // SEARCH
  // ------------------------------------------------------
  void searchProducts(String query) {
    if (query.isEmpty) {
      filteredProducts.assignAll(masterList);
      return;
    }

    final q = query.toLowerCase();

    filteredProducts.assignAll(
      masterList.where((p) {
        final nameMatch = p.name?.toLowerCase().contains(q) ?? false;
        final skuMatch = p.sku?.toLowerCase().contains(q) ?? false;
        return nameMatch || skuMatch;
      }).toList(),
    );
  }

  // ------------------------------------------------------
  // DELETE PRODUCT
  // ------------------------------------------------------
  Future<void> deleteProduct(int productId) async {
    final response = await productService.deleteProductFromApi(productId);

    if (response) {
      /// ProductService will automatically update masterList
      AppHelpers.showSnackBar(
        title: "Success",
        message: "Product deleted successfully!",
        isError: false,
      );
    } else {
      AppHelpers.showSnackBar(
        title: "Error",
        message: "Failed to delete product.",
        isError: true,
      );
    }
  }

  // ------------------------------------------------------
  // NAVIGATION
  // ------------------------------------------------------
  Future<void> goToAddProduct() async {
    final result = await Get.toNamed(Routes.addProduct);

    if (result == true) {
      // Service will sync automatically
    }
  }

  Future<void> gotoEditProduct(Product product) async {
    final result =
    await Get.toNamed(Routes.addProduct, arguments: product);

    if (result == true) {
      // Service will sync automatically
    }
  }
}
