import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/core/bindings/app_bindings.dart';
import 'app/core/themes/app_theme.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';

void main() async {
  // 1. Initialize Bindings FIRST to avoid errors with platform channels
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Load Environment variables
  await dotenv.load(fileName: ".env");

  // 3. Initialize Storage
  await GetStorage.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Check for token
    final storage = GetStorage();
    // Alternatively, if you use your StorageService wrapper:
    // final token = StorageServices().getToken();
    // But raw GetStorage is safe here since controller isn't ready yet.
    final String? token = storage.read('token'); // Ensure key matches what you used in setToken

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      darkTheme: AppTheme.dark,
      theme: AppTheme.light,
      // 2. Determine Initial Route based on token existence
      initialRoute: (token != null && token.isNotEmpty)
          ? Routes.dashboard
          : Routes.auth,
      getPages: AppPages.routes,
      initialBinding: AppBindings(),
    );
  }
}

