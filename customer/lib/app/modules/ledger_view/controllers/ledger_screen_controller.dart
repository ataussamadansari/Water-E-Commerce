import 'package:get/get.dart';
import '../../../data/services/ledger/ledger_service.dart';

class LedgerScreenController extends GetxController {
  final LedgerService _ledgerService = Get.put(LedgerService());

  get ledgerData => _ledgerService.ledgerData;
  bool get isLoading => _ledgerService.isLoading.value;
  RxBool get isError => _ledgerService.isError;
  RxString get hasError => _ledgerService.hasError;

  // Filter Logic
  final List<String> filterOptions = ['All', 'Created', 'Assigned', 'Delivered'];
  final RxString selectedFilter = 'All'.obs;

  // Computed property for filtered orders
  List<dynamic> get filteredOrders {
    final data = ledgerData.value;
    if (data == null || data.orders == null) return [];
    
    final allOrders = data.orders!;
    
    if (selectedFilter.value == 'All') {
      return allOrders;
    }

    return allOrders.where((order) {
      final status = order.status?.toLowerCase() ?? '';
      return status == selectedFilter.value.toLowerCase();
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    fetchLedger();
  }

  Future<void> fetchLedger() async {
    await _ledgerService.fetchLedger();
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
  }
}
