import 'package:get/get.dart';
import '../../../data/models/customers/customer_model.dart';
import '../../../data/services/customer/customer_service.dart';
import '../../../routes/app_routes.dart';

// Enum to define filter states
enum CustomerFilter { all, approved, pending }

class CustomersScreenController extends GetxController {
  final CustomerService customerService = Get.find<CustomerService>();

  RxList<Customer> get masterList => customerService.customers;

  final RxList<Customer> filteredCustomers = <Customer>[].obs;

  final Rx<CustomerFilter> currentFilter = CustomerFilter.all.obs;
  String _currentSearchQuery = '';

  @override
  void onInit() {
    super.onInit();

    /// Whenever customers updated in service → reflect on screen
    ever(customerService.customers, (_) {
      _applyFilters();
    });

    /// Initial UI setup
    filteredCustomers.assignAll(masterList);
  }

  // ----------------------------------------------------------------------
  // SEARCH LOGIC
  // ----------------------------------------------------------------------
  void search(String query) {
    _currentSearchQuery = query;
    _applyFilters();
  }

  // ----------------------------------------------------------------------
  // FILTER LOGIC
  // ----------------------------------------------------------------------
  void setFilter(CustomerFilter filter) {
    currentFilter.value = filter;
    _applyFilters();
  }

  // ----------------------------------------------------------------------
  // COMBINED FILTER + SEARCH
  // ----------------------------------------------------------------------
  void _applyFilters() {
    List<Customer> tempList = List.from(masterList);

    // 1. Filter by status
    if (currentFilter.value == CustomerFilter.approved) {
      tempList = tempList.where((c) => c.isApproved == true).toList();
    } else if (currentFilter.value == CustomerFilter.pending) {
      tempList = tempList.where((c) => c.isApproved != true).toList();
    }

    // 2. Search filter
    if (_currentSearchQuery.isNotEmpty) {
      final query = _currentSearchQuery.toLowerCase();

      tempList = tempList.where((c) {
        final nameMatch = c.shopName?.toLowerCase().contains(query) ?? false;
        final mobileMatch = c.mobile?.contains(query) ?? false;
        return nameMatch || mobileMatch;
      }).toList();
    }

    filteredCustomers.assignAll(tempList);
  }

  // ----------------------------------------------------------------------
  // NAVIGATION
  // ----------------------------------------------------------------------
  void gotoDetails(Customer customer) async {
    final result = await Get.toNamed(
      Routes.customerDetails,
      arguments: customer,
    );

    if (result == true) {
      customerService.fetchCustomers();
    }
  }
}
