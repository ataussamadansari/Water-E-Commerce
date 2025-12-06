import 'package:get/get.dart';
import '../core/api_service.dart';

class SaleController extends GetxController {
  final ApiService _apiService = ApiService();
  final sales = <Map<String, dynamic>>[].obs;
  final products = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSales();
    fetchProducts();
  }

  Future<void> fetchSales() async {
    try {
      isLoading.value = true;
      final response = await _apiService.getSales();

      if (response.statusCode == 200) {
        sales.value = List<Map<String, dynamic>>.from(
          response.data['data'] ?? [],
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch sales: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      final response = await _apiService.getProducts();

      if (response.statusCode == 200) {
        products.value = List<Map<String, dynamic>>.from(
          response.data['data'] ?? [],
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch products: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createSale(Map<String, dynamic> saleData) async {
    try {
      isLoading.value = true;
      final response = await _apiService.createSale(saleData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Success', 'Sale created successfully');
        fetchSales();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to create sale: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }
}
