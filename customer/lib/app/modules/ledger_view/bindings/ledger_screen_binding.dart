import 'package:get/get.dart';
import '../controllers/ledger_screen_controller.dart';

class LedgerScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LedgerScreenController>(
      () => LedgerScreenController(),
    );
  }
}
