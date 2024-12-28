import 'package:get/get.dart';

class UserController extends GetxController {
  // Variables to store user information globally
  var token = ''.obs;
  var email = ''.obs;
  var role = ''.obs;
  var provider = ''.obs;
  var isAuthenticated = false.obs;
  var tokenExpired = false.obs;

  // Method to set user data
  void setUserData(String userToken, String userEmail, String userRole,
      String userProvider, bool isTokenExpired) {
    token.value = userToken;
    email.value = userEmail;
    role.value = userRole;
    provider.value = userProvider;
    tokenExpired.value = isTokenExpired;
    isAuthenticated.value = true;
  }

  // Method to clear user data (Logout)
  void clearUserData() {
    token.value = '';
    email.value = '';
    role.value = '';
    provider.value = '';
    tokenExpired.value = false;
    isAuthenticated.value = false;
  }
}
