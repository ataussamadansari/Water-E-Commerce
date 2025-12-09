import 'package:get/get.dart';
import '../controllers/users_screen_controller.dart';

class UsersScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UsersScreenController>(
      () => UsersScreenController(),
    );
  }
}
