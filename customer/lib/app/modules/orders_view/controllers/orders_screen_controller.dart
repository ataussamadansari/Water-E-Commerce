import 'package:customer/app/data/services/orders/order_service.dart';
import 'package:get/get.dart';
import '../../../data/models/order/order_model.dart';

class OrdersScreenController extends GetxController {
  final OrderService _orderService = Get.find<OrderService>();

  // Filter Logic
  final List<String> filterOptions = ['All', 'Assigned', 'Delivered', 'Cancelled'];
  final RxString selectedFilter = 'All'.obs;

  RxList<OrderData> get orders => _orderService.orders;
  
  // Computed property for filtered orders
  List<OrderData> get filteredOrders {
    if (selectedFilter.value == 'All') {
      return orders;
    }
    return orders.where((order) {
      final status = order.status?.toLowerCase() ?? '';
      return status == selectedFilter.value.toLowerCase();
    }).toList();
  }

  bool get isLoading => _orderService.isLoading.value;
  RxBool get isError => _orderService.isError;
  RxString get hasError => _orderService.hasError;

  @override
  void onInit() {
    super.onInit();
    refreshOrders();
  }

  Future<void> refreshOrders() async {
    await _orderService.fetchOrders();
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
  }
}
