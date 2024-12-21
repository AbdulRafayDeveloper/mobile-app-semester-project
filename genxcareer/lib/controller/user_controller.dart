import 'package:get/get.dart';

class UserController extends GetxController {
  // Variables to store user information globally
  var token = ''.obs;
  var email = ''.obs;
  var role = ''.obs;
  var isAuthenticated = false.obs;
  var tokenExpired = false.obs; // New variable to track token expiration

  // Method to set user data
  void setUserData(String userToken, String userEmail, String userRole,
      bool isTokenExpired) {
    token.value = userToken;
    email.value = userEmail;
    role.value = userRole;
    tokenExpired.value = isTokenExpired; // Set the token expiration status
    isAuthenticated.value = true;
  }

  // Method to clear user data (Logout)
  void clearUserData() {
    token.value = '';
    email.value = '';
    role.value = '';
    tokenExpired.value = false; // Reset token expiration flag
    isAuthenticated.value = false;
  }
}
