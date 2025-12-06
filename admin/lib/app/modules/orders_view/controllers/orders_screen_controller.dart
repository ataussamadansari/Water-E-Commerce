import 'package:admin/app/data/models/orders/order_model.dart';
import 'package:admin/app/data/services/order/order_service.dart';
import 'package:admin/app/routes/app_routes.dart';
import 'package:get/get.dart';

// Enum to define filter states
enum OrderFilter { all, approved, pending, cancelled, delivered }

class OrdersScreenController extends GetxController {
  // Inject the shared service
  final OrderService _orderService = Get.find<OrderService>();

  // Observables for UI
  final RxList<Order> filteredOrders = <Order>[].obs;

  // Track current state
  final Rx<OrderFilter> currentFilter = OrderFilter.all.obs;
  String _currentSearchQuery = '';

  // Getters from Service
  bool get isLoading => _orderService.isLoading.value;

  @override
  void onInit() {
    super.onInit();
    // Listen to changes in the master list from service and re-apply filters automatically
    ever(_orderService.orders, (_) => _applyFilters());

    // Initial load
    _applyFilters();
  }

  // --- Search Logic ---
  void search(String query) {
    _currentSearchQuery = query;
    _applyFilters();
  }

  // --- Filter Logic ---
  void setFilter(OrderFilter filter) {
    currentFilter.value = filter;
    _applyFilters();
  }

  void _applyFilters() {
    List<Order> tempList = _orderService.orders;

    // 1. Apply Status Filter
    switch (currentFilter.value) {
      case OrderFilter.approved:
        tempList = tempList.where((o) => o.status?.toLowerCase() == 'approved').toList();
        break;
      case OrderFilter.pending:
        tempList = tempList.where((o) => o.status?.toLowerCase() == 'pending').toList();
        break;
      case OrderFilter.delivered:
        tempList = tempList.where((o) => o.status?.toLowerCase() == 'delivered').toList();
        break;
      case OrderFilter.cancelled:
        tempList = tempList.where((o) => o.status?.toLowerCase() == 'cancelled').toList();
        break;
      case OrderFilter.all:
      default:
        break;
    }

    // 2. Apply Search Query
    if (_currentSearchQuery.isNotEmpty) {
      final query = _currentSearchQuery.toLowerCase();
      tempList = tempList.where((o) {
        final idMatch = o.id?.toString().contains(query) ?? false;
        final orderNoMatch = o.orderNo?.toLowerCase().contains(query) ?? false;
        final customerMatch = o.customer?.shopName?.toLowerCase().contains(query) ?? false;
        return idMatch || orderNoMatch || customerMatch;
      }).toList();
    }

    filteredOrders.assignAll(tempList);
  }

  // --- Actions ---

  Future<void> refreshOrders() async {
    await _orderService.fetchOrders();
  }

  void gotoOrderDetails(Order order) {
    // Navigate to details screen (pass the order object)
    // Get.toNamed(Routes.orderDetails, arguments: order);
  }
}
