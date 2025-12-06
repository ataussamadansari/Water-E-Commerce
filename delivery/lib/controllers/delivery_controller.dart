import 'package:get/get.dart';
import '../core/api_service.dart';

class DeliveryController extends GetxController {
  final ApiService _apiService = ApiService();
  final deliveries = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDeliveries();
  }

  Future<void> fetchDeliveries() async {
    try {
      isLoading.value = true;
      final response = await _apiService.getDeliveries();

      if (response.statusCode == 200) {
        deliveries.value = List<Map<String, dynamic>>.from(
          response.data['data'] ?? [],
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch deliveries: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateDeliveryStatus(int id, String status) async {
    try {
      isLoading.value = true;
      final response = await _apiService.updateDeliveryStatus(id, status);

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Delivery status updated');
        fetchDeliveries();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update status: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }
}
