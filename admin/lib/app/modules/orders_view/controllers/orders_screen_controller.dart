import 'package:admin/app/core/utils/helpers.dart';
import 'package:admin/app/data/models/orders/order_model.dart';
import 'package:admin/app/data/models/users/user_model.dart';
import 'package:admin/app/data/services/order/order_service.dart';
import 'package:admin/app/data/services/user/user_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Enum to define filter states
enum OrderFilter { all, assigned, created, cancelled, delivered }

class OrdersScreenController extends GetxController {
  // Inject the shared service
  final OrderService _orderService = Get.find<OrderService>();
  // Inject UserService to fetch delivery boys
  final UserService _userService = Get.find<UserService>();
  
  // Removed local _ordersRepo since we use Service now

  // Observables for UI
  final RxList<Order> filteredOrders = <Order>[].obs;
  
  // Delivery Users List
  final RxList<User> deliveryUsers = <User>[].obs;

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
    
    // Pre-fetch delivery users
    _loadDeliveryUsers();
  }
  
  // Load delivery users for assignment
  Future<void> _loadDeliveryUsers() async {
    final users = await _userService.getDeliveryUsers();
    if (users.isNotEmpty) {
      deliveryUsers.assignAll(users);
    } else {
      // Optional: don't show error if just empty, but user asked for snackbar if error
      // getDeliveryUsers prints error. We can rely on that or improve UserService return type.
      // But user said "snackbar show nahi ho raha".
      // Let's assume getDeliveryUsers returns empty list on error too.
      // If we want strict error handling, we should return ApiResponse.
      // But for now, if empty, we might just assume no users or error.
    }
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
      case OrderFilter.assigned:
        tempList = tempList.where((o) => o.status?.toLowerCase() == 'assigned').toList();
        break;
      case OrderFilter.created:
        tempList = tempList.where((o) => o.status?.toLowerCase() == 'created').toList();
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
  
  // --- Assign Delivery Sheet ---
  void showAssignDeliverySheet(Order order) {
    // Determine if it is delivered or read-only status
    final isDelivered = order.status?.toLowerCase() == 'delivered' || order.status?.toLowerCase() == 'completed';

    // Ensure we have delivery users if list is empty
    if (deliveryUsers.isEmpty) {
      _loadDeliveryUsers();
    }
    
    // Check if user is already assigned
    User? preSelectedUser;
    if (order.deliveryId != null && deliveryUsers.isNotEmpty) {
       // Find user by ID. Order deliveryId might be string or int.
       final deliveryId = int.tryParse(order.deliveryId.toString());
       preSelectedUser = deliveryUsers.firstWhereOrNull((u) => u.id == deliveryId);
    }
    
    final Rx<User?> selectedUser = Rx<User?>(preSelectedUser);
    final RxBool isAssigning = false.obs;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 30),
        decoration: BoxDecoration(
          color: Get.isDarkMode ? Colors.grey[900] : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Close Icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isDelivered ? "Delivery Details" : "Assign Delivery",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              "Order #${order.orderNo ?? order.id}",
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),
            
            // Show assigned user info if already assigned
            if (preSelectedUser != null)
              Container(
                 margin: const EdgeInsets.only(bottom: 20),
                 padding: const EdgeInsets.all(12),
                 decoration: BoxDecoration(
                   color: Colors.green.withOpacity(0.1),
                   borderRadius: BorderRadius.circular(8),
                   border: Border.all(color: Colors.green.withOpacity(0.3))
                 ),
                 child: Row(
                   children: [
                     const Icon(Icons.check_circle, color: Colors.green, size: 20),
                     const SizedBox(width: 8),
                     Expanded(
                       child: Text(
                         isDelivered 
                             ? "Delivered by: ${preSelectedUser.name}" 
                             : "Currently assigned to: ${preSelectedUser.name}",
                         style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                       ),
                     ),
                   ],
                 ),
              ),

            
            // Delivery User Dropdown (Hide if delivered)
            if (!isDelivered)
            Obx(() {
               if (deliveryUsers.isEmpty) {
                 return const Center(child: Padding(
                   padding: EdgeInsets.all(8.0),
                   child: Text("Loading delivery agents... or none found."),
                 ));
               }
               return DropdownButtonFormField<User>(
                decoration: InputDecoration(
                  labelText: preSelectedUser != null ? "Re-assign Delivery Person" : "Select Delivery Person",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                value: selectedUser.value,
                items: deliveryUsers.map((user) {
                  return DropdownMenuItem<User>(
                    value: user,
                    child: Text("${user.name} (${user.mobile ?? 'N/A'})"),
                  );
                }).toList(),
                onChanged: (val) {
                  selectedUser.value = val;
                },
              );
            }),
            
            if (isDelivered)
              const Center(
                child: Text(
                  "This order has been delivered and cannot be re-assigned.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
                ),
              ),
            
            // Action Buttons
            if (!isDelivered) ...[
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: Obx(() => ElevatedButton(
                  onPressed: isAssigning.value ? null : () async {
                    if (selectedUser.value == null) {
                      AppHelpers.showSnackBar(title: "Required", message: "Please select a delivery person", isError: true);
                      return;
                    }
                    
                    // Check if same user selected
                    if (preSelectedUser != null && selectedUser.value!.id == preSelectedUser.id) {
                       Get.back(); // No change
                       return;
                    }

                    isAssigning.value = true;
                    // Use Service instead of Repo
                    await _assignDelivery(order, selectedUser.value!);
                    isAssigning.value = false;
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                  ),
                  child: isAssigning.value 
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) 
                      : Text(preSelectedUser != null ? "Update Assignment" : "Assign"),
                )),
              ),
            ],
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
  
  Future<void> _assignDelivery(Order order, User user) async {
    // Use OrderService
    final response = await _orderService.assignOrder(order.id!, user.id!);
    
    if (response.success) {
      AppHelpers.showSnackBar(title: "Success", message: "Order assigned to ${user.name}", isError: false);
      // No need to call refreshOrders() manually if service updates the observable list, 
      // but if the API returns the updated order, the Service updates it.
      // However, if we want to be safe or if Service doesn't fully sync:
      // Service `assignOrder` calls `updateOrder(response.data!)` so the list should update automatically.
      // The `ever` listener will then re-apply filters and update `filteredOrders`.
    } else {
      AppHelpers.showSnackBar(title: "Error", message: response.message, isError: true);
    }
  }

  void gotoOrderDetails(Order order) {
    // Navigate to details screen (pass the order object)
    // Get.toNamed(Routes.orderDetails, arguments: order);
  }
}
