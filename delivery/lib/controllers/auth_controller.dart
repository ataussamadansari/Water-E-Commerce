import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/api_service.dart';

class AuthController extends GetxController {
  final ApiService _apiService = ApiService();
  final isLoading = false.obs;
  final isLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    isLoggedIn.value = token != null;
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      final response = await _apiService.login(email, password);

      if (response.statusCode == 200) {
        final token = response.data['token'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        isLoggedIn.value = true;
        Get.offAllNamed('/home');
        Get.snackbar('Success', 'Login successful');
      }
    } catch (e) {
      Get.snackbar('Error', 'Login failed: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    isLoggedIn.value = false;
    Get.offAllNamed('/login');
  }
}
