import 'package:get/get.dart';
import '../../models/products/product_model.dart';
import '../../repositories/products/product_repository.dart';

class ProductService extends GetxService {
  final ProductsRepository _repo = ProductsRepository();

  final RxList<ProductModel> products = <ProductModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isError = false.obs;
  final RxString hasError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    isLoading.value = true;
    isError.value = false;
    hasError.value = '';

    final res = await _repo.getProducts();
    if (res.success && res.data != null) {
      // res.data is ProductsResponse
      products.assignAll(res.data!.data ?? []);
    } else {
      isError.value = true;
      hasError.value = res.message;
    }

    isLoading.value = false;
  }

  Future<ProductModel?> getProductById(num id) async {
    final res = await _repo.getProductById(id);
    if (res.success && res.data != null) {
      return res.data!;
    }
    return null;
  }

  // Local update helpers (if used)
  void updateProductLocal(ProductModel updated) {
    final idx = products.indexWhere((p) => p.id == updated.id);
    if (idx != -1) {
      products[idx] = updated;
      products.refresh();
    }
  }
}
