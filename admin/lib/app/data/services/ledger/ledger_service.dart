import 'package:get/get.dart';
import '../../models/ledger/ledger_response.dart';
import '../../repositories/ledger/ledger_repository.dart';

class LedgerService extends GetxService {
  final LedgerRepository _ledgerRepo = LedgerRepository();

  final Rx<LedgerData?> ledgerData = Rx<LedgerData?>(null);
  final RxBool isLoading = false.obs;

  Future<void> fetchLedger(int customerId) async {
    try {
      isLoading.value = true;
      final response = await _ledgerRepo.getCustomerLedger(customerId);
      if (response.success && response.data != null) {
        ledgerData.value = response.data!.data;
      } else {
        ledgerData.value = null;
      }
    } finally {
      isLoading.value = false;
    }
  }
}
