import 'package:admin/app/modules/add_product_view/bindings/add_product_screen_binding.dart';
import 'package:admin/app/modules/add_product_view/views/add_product_screen.dart';
import 'package:admin/app/modules/add_region_view/bindings/add_region_screen_binding.dart';
import 'package:admin/app/modules/add_region_view/views/add_region_screen.dart';
import 'package:admin/app/modules/auth_view/bindings/auth_screen_binding.dart';
import 'package:admin/app/modules/auth_view/views/auth_screen.dart';
import 'package:admin/app/modules/customer_details_view/bindings/customer_details_screen_binding.dart';
import 'package:admin/app/modules/customer_details_view/views/customer_details_screen.dart';
import 'package:admin/app/modules/dashboard_view/bindings/dashboard_screen_binding.dart';
import 'package:admin/app/modules/dashboard_view/views/dashboard_screen.dart';
import 'package:admin/app/modules/manage_stock_view/bindings/manage_stock_screen_binding.dart';
import 'package:admin/app/modules/manage_stock_view/views/manage_stock_screen.dart';
import 'package:admin/app/modules/orders_view/bindings/orders_screen_binding.dart';
import 'package:admin/app/modules/orders_view/views/orders_screen.dart';
import 'package:admin/app/modules/products_view/bindings/products_screen_binding.dart';
import 'package:admin/app/modules/products_view/views/products_screen.dart';
import 'package:admin/app/modules/regions_view/bindings/regions_screen_binding.dart';
import 'package:admin/app/modules/regions_view/views/regions_screen.dart';
import 'package:get/get.dart';

import '../modules/customers_view/bindings/customers_screen_binding.dart';
import '../modules/customers_view/views/customers_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.auth,
      page: () => AuthScreen(),
      binding: AuthScreenBinding(),
    ),
    GetPage(
      name: Routes.dashboard,
      page: () => DashboardScreen(),
      binding: DashboardScreenBinding(),
    ),

    // Orders
    GetPage(
      name: Routes.orders,
      page: () => OrdersScreen(),
      binding: OrdersScreenBinding(),
    ),

    // Customers
    GetPage(
      name: Routes.customers,
      page: () => CustomersScreen(),
      binding: CustomersScreenBinding(),
    ),
    GetPage(
      name: Routes.customerDetails,
      page: () => CustomerDetailsScreen(),
      binding: CustomerDetailsScreenBinding(),
    ),

    // Products
    GetPage(
      name: Routes.products,
      page: () => ProductsScreen(),
      binding: ProductsScreenBinding(),
    ),
    GetPage(
      name: Routes.addProduct,
      page: () => AddProductScreen(),
      binding: AddProductScreenBinding(),
    ),
    GetPage(
      name: Routes.manageStock,
      page: () => ManageStockScreen(),
      binding: ManageStockScreenBinding(),
    ),

    // Regions
    GetPage(
      name: Routes.regions,
      page: () => RegionsScreen(),
      binding: RegionsScreenBinding(),
    ),
    GetPage(
      name: Routes.addRegions,
      page: () => AddRegionScreen(),
      binding: AddRegionScreenBinding(),
    ),
  ];
}
