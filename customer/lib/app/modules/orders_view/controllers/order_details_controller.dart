import 'package:get/get.dart';
import '../../../data/services/orders/order_service.dart';
import '../../../data/models/order/single_order_response.dart';

class OrderDetailsController extends GetxController {
  final OrderService _orderService = Get.find<OrderService>();

  final Rx<SingleOrderResponse?> order = Rx<SingleOrderResponse?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isError = false.obs;
  final RxString hasError = ''.obs;
  
  int orderId = 0;

  @override
  void onInit() {
    super.onInit();
    // Get ID from arguments
    if (Get.arguments != null) {
      orderId = Get.arguments as int;
      fetchOrderDetails(orderId);
    }
  }

  Future<void> fetchOrderDetails(int id) async {
    isLoading.value = true;
    isError.value = false;
    hasError.value = "";

    try {
      final response = await _orderService.getOrderById(id);
      if (response != null) {
        order.value = response;
      } else {
        isError.value = true;
        hasError.value = _orderService.hasError.value;
      }
    } catch (e) {
      isError.value = true;
      hasError.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
