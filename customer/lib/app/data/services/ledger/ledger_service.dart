import 'package:get/get.dart';
import '../../models/ledger/ledger_response.dart';
import '../../repositories/ledger/ledger_repository.dart';

class LedgerService extends GetxService {
  final LedgerRepository _repo = LedgerRepository();

  final Rx<LedgerData?> ledgerData = Rx<LedgerData?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isError = false.obs;
  final RxString hasError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLedger(); 
  }

  Future<void> fetchLedger() async {
    isLoading.value = true;
    isError.value = false;
    hasError.value = "";

    final response = await _repo.getLedger();

    if (response.success && response.data != null) {
      ledgerData.value = response.data!.data;
    } else {
      isError.value = true;
      hasError.value = response.message;
    }

    isLoading.value = false;
  }
}
