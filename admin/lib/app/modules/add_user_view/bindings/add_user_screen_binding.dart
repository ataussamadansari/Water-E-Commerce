import 'package:get/get.dart';
import '../controllers/add_user_screen_controller.dart';

class AddUserScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddUserScreenController>(
      () => AddUserScreenController(),
    );
  }
}
