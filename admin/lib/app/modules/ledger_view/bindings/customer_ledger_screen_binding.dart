import 'package:get/get.dart';
import '../controllers/customer_ledger_screen_controller.dart';

class CustomerLedgerScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomerLedgerScreenController>(
      () => CustomerLedgerScreenController(),
    );
  }
}
