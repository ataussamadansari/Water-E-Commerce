import 'package:get/get.dart';
import '../../models/orders/order_model.dart';
import '../../repositories/orders/orders_repository.dart';

class OrderService extends GetxService {
  final OrdersRepository _ordersRepo = OrdersRepository();

  /// Master list for entire app
  final RxList<Order> orders = <Order>[].obs;

  /// Loading state
  final RxBool isLoading = false.obs;
  final RxBool isError = false.obs;
  final RxString hasError = ''.obs;

  int get pendingOrdersCount {
    return orders.where((o) {
      final status = o.status?.toLowerCase();
      return status == 'pending' || status == 'created';
    }).length;
  }

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  // ----------------------------------------------------------------------
  // FETCH ALL ORDERS
  // ----------------------------------------------------------------------
  Future<void> fetchOrders() async {
    isLoading.value = true;

    final response = await _ordersRepo.getOrders();

    if (response.success && response.data != null) {
      orders.assignAll(response.data!.data!);
    } else {
      hasError.value = response.message;
      isError.value = true;
    }

    isLoading.value = false;
  }

  // ----------------------------------------------------------------------
  // GET SINGLE ORDER BY ID
  // ----------------------------------------------------------------------
  Future<Order?> getOrderById(int id) async {
    final response = await _ordersRepo.getOrderById(id);

    if (response.success) {
      return response.data!;
    }
    return null;
  }

  // ----------------------------------------------------------------------
  // CREATE ORDER (API → LOCAL UPDATE)
  // ----------------------------------------------------------------------
  Future<bool> createOrderFromApi(Map<String, dynamic> data) async {
    final response = await _ordersRepo.createOrder(data);

    if (response.success && response.data != null) {
      addOrder(response.data!); // Local Sync
      return true;
    }
    return false;
  }

  void addOrder(Order order) {
    orders.insert(0, order);
  }

  // ----------------------------------------------------------------------
  // UPDATE ORDER (API → LOCAL UPDATE)
  // ----------------------------------------------------------------------
  Future<bool> updateOrderFromApi(int id, Map<String, dynamic> data) async {
    final response = await _ordersRepo.updateOrder(id, data);

    if (response.success && response.data != null) {
      updateOrder(response.data!);
      return true;
    }
    return false;
  }

  void updateOrder(Order updatedOrder) {
    final index = orders.indexWhere((o) => o.id == updatedOrder.id);
    if (index != -1) {
      orders[index] = updatedOrder;
      orders.refresh();
    }
  }

  // ----------------------------------------------------------------------
  // UPDATE ORDER STATUS ONLY
  // ----------------------------------------------------------------------
  Future<bool> updateOrderStatusFromApi(int id, String status) async {
    final response = await _ordersRepo.updateOrderStatus(id, status);

    if (response.success && response.data != null) {
      updateOrder(response.data!);
      return true;
    }
    return false;
  }

  // ----------------------------------------------------------------------
  // DELETE ORDER (API → LOCAL UPDATE)
  // ----------------------------------------------------------------------
  Future<bool> deleteOrderFromApi(int id) async {
    final response = await _ordersRepo.deleteOrder(id);

    if (response.success) {
      deleteOrder(id);
      return true;
    }

    return false;
  }

  void deleteOrder(int id) {
    orders.removeWhere((o) => o.id == id);
  }
}
