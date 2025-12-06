import 'package:get/get.dart';
import '../../models/products/product_model.dart';
import '../../repositories/products/products_repository.dart';

class ProductService extends GetxService {
  final ProductRepository _productRepo = ProductRepository();

  // MASTER STATE
  final RxList<Product> products = <Product>[].obs;
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
    final response = await _productRepo.getProducts();

    if (response.success && response.data != null) {
      products.assignAll(response.data!.data!);
    } else {
      hasError.value = response.message;
      isError.value = true;
    }
    isLoading.value = false;
  }

  void addProduct(Product newProduct) {
    products.insert(0, newProduct);
  }

  void updateProduct(Product updatedProduct) {
    final index = products.indexWhere((p) => p.id == updatedProduct.id);
    if (index != -1) {
      products[index] = updatedProduct;
      products.refresh();
    }
  }

  /// ---------------------------------------------------------
  /// NEW: Update Product via API and sync local state
  /// ---------------------------------------------------------
  Future<bool> updateProductFromApi(int id, Map<String, dynamic> data) async {
    final res = await _productRepo.updateProduct(id, data);

    if (res.success && res.data != null) {
      // API call successful -> Update local master list
      updateProduct(res.data!);
      return true;
    }
    return false;
  }

  Future<bool> deleteProductFromApi(int id) async {
    final res = await _productRepo.deleteProduct(id);
    if (res.success) {
      deleteProduct(id);
      return true;
    }
    return false;
  }

  void deleteProduct(int productId) {
    products.removeWhere((p) => p.id == productId);
  }
}


/*
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../core/utils/helpers.dart';
import '../../models/products/product_model.dart';
import '../../repositories/products/products_repository.dart';

class ProductService extends GetxService {
  final ProductRepository _productRepo = ProductRepository();

  // =================================================================
  // MASTER STATE: The single source of truth for product data
  // =================================================================
  final RxList<Product> products = <Product>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isError = false.obs;
  final RxString hasError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts(); // Load initial data when the app starts
  }

  /// Fetches the complete list of products from the API and updates the master list.
  Future<void> fetchProducts() async {
    isLoading.value = true;
    final response = await _productRepo.getProducts();

    if (response.success && response.data != null) {
      products.assignAll(response.data!.data!);
    } else {
      hasError.value = response.message;
      isError.value = true;
    }
    isLoading.value = false;
  }

  /// Adds a new product to the local master list for an instant UI update.
  /// This should be called after a successful API "create" call.
  void addProduct(Product newProduct) {
    products.insert(0, newProduct);
  }

  /// Updates an existing product in the local master list.
  /// This should be called after a successful API "update" call.
  void updateProduct(Product updatedProduct) {
    final index = products.indexWhere((p) => p.id == updatedProduct.id);
    if (index != -1) {
      products[index] = updatedProduct;
      products.refresh();
    }
  }

  /// Deletes a product from the local master list.
  /// This should be called after a successful API "delete" call.

  Future<bool> deleteProductFromApi(int id) async {
    final res = await _productRepo.deleteProduct(id);
    if (res.success) {
      deleteProduct(id); // local update
      return true;
    }
    return false;
  }

  void deleteProduct(int productId) {
    products.removeWhere((p) => p.id == productId);
  }
}
*/
