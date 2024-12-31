import 'package:get/get.dart';

class UserController extends GetxController {
  
  var token = ''.obs;
  var email = ''.obs;
  var role = ''.obs;
  var provider = ''.obs;
  var isAuthenticated = false.obs;
  var tokenExpired = false.obs;

  
  void setUserData(String userToken, String userEmail, String userRole,
      String userProvider, bool isTokenExpired) {
    token.value = userToken;
    email.value = userEmail;
    role.value = userRole;
    provider.value = userProvider;
    tokenExpired.value = isTokenExpired;
    isAuthenticated.value = true;
  }

  void clearUserData() {
    token.value = '';
    email.value = '';
    role.value = '';
    provider.value = '';
    tokenExpired.value = false;
    isAuthenticated.value = false;
  }
}
