import 'package:get/get.dart';
import '../../../data/services/ledger/ledger_service.dart';

class LedgerScreenController extends GetxController {
  final LedgerService _ledgerService = Get.put(LedgerService());

  get ledgerData => _ledgerService.ledgerData;
  bool get isLoading => _ledgerService.isLoading.value;
  RxBool get isError => _ledgerService.isError;
  RxString get hasError => _ledgerService.hasError;

  @override
  void onInit() {
    super.onInit();
    fetchLedger();
  }

  Future<void> fetchLedger() async {
    await _ledgerService.fetchLedger();
  }
}
