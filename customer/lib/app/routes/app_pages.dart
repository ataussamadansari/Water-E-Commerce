import 'package:customer/app/modules/orders_view/bindings/orders_screen_binding.dart';
import 'package:customer/app/modules/orders_view/views/orders_screen.dart';
import 'package:get/get.dart';

import '../modules/auth_view/bindings/auth_screen_binding.dart';
import '../modules/auth_view/views/auth_screen.dart';
import '../modules/home_view/bindings/home_screen_binding.dart';
import '../modules/home_view/views/home_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.auth,
      page: () => AuthScreen(),
      binding: AuthScreenBinding(),
    ),

    GetPage(
      name: Routes.home,
      page: () => HomeScreen(),
      binding: HomeScreenBinding(),
    ),

    GetPage(
      name: Routes.orders,
      page: () => OrdersScreen(),
      binding: OrdersScreenBinding(),
    ),

  ];
}
