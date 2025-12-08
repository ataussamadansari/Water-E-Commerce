import 'package:customer/app/modules/orders_view/bindings/orders_screen_binding.dart';
import 'package:customer/app/modules/orders_view/views/orders_screen.dart';
import 'package:customer/app/modules/profile_view/bindings/profile_screen_binding.dart';
import 'package:customer/app/modules/profile_view/views/profile_screen.dart';
import 'package:get/get.dart';

import '../modules/auth_view/bindings/auth_screen_binding.dart';
import '../modules/auth_view/views/auth_screen.dart';
import '../modules/home_view/bindings/home_screen_binding.dart';
import '../modules/home_view/views/home_screen.dart';
import '../modules/orders_view/views/order_details_screen.dart';
import '../modules/orders_view/controllers/order_details_controller.dart';
import '../modules/ledger_view/bindings/ledger_screen_binding.dart';
import '../modules/ledger_view/views/ledger_screen.dart';
import '../modules/cart_view/bindings/cart_screen_binding.dart';
import '../modules/cart_view/views/cart_screen.dart';
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

    GetPage(
      name: Routes.orderDetails,
      page: () => OrderDetailsScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => OrderDetailsController());
      }),
    ),

    GetPage(
      name: Routes.profile,
      page: () => ProfileScreen(),
      binding: ProfileScreenBinding(),
    ),
    
    GetPage(
      name: Routes.ledger,
      page: () => LedgerScreen(),
      binding: LedgerScreenBinding(),
    ),

    GetPage(
      name: Routes.cart,
      page: () => CartScreen(),
      binding: CartScreenBinding(),
    ),

  ];
}
