import 'package:get/get.dart';
import '../../models/profile/profile_response.dart';
import '../../repositories/profile/profile_repository.dart';

class ProfileService extends GetxService {
  final ProfileRepository _repo = ProfileRepository();

  final Rx<Data?> profileData = Rx<Data?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isError = false.obs;
  final RxString hasError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    isLoading.value = true;
    isError.value = false;
    hasError.value = "";

    final response = await _repo.getProfile();

    if (response.success && response.data != null) {
      profileData.value = response.data!.data;
    } else {
      isError.value = true;
      hasError.value = response.message;
    }

    isLoading.value = false;
  }

  Future<bool> updateProfile(dynamic data) async {
    isLoading.value = true; 
    
    final response = await _repo.updateProfile(data);

    if (response.success && response.data != null) {
      // Instantly update the local profile data
      profileData.value = response.data!.data;
      isLoading.value = false;
      return true;
    } else {
      hasError.value = response.message;
      isLoading.value = false;
      return false;
    }
  }
}
