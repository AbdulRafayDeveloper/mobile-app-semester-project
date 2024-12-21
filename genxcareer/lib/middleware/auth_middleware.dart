import 'package:genxcareer/controller/user_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final userController = Get.find<UserController>();

    print("Check Middlware");
    print("Middleware triggered for route: $route");
    print("User isAuthenticated: ${userController.isAuthenticated.value}");
    print("User role: ${userController.role.value}");
    print("User token: ${userController.token.value}");

    if (route == '/signIn' && !userController.isAuthenticated.value) {
      print("User is already on the signIn page.");
      return null;
    }

    if (route == '/signUp' && !userController.isAuthenticated.value) {
      print("User is already on the signUp page.");
      return null;
    }

    // Default redirection to the sign-in page for unauthenticated users
    if (!userController.isAuthenticated.value ||
        userController.token.value.isEmpty) {
      if (route != 'signUp' &&
          route != 'signIn' &&
          route != 'userJobs' &&
          route != 'userJobDetailsPage') {
        print("Redirecting to signIn due to unauthenticated user");
        return const RouteSettings(name: '/signIn');
      }
      return null;
    }

    // Handle admin-specific logic

    if (userController.role.value == 'admin') {
      if (route == '/signIn' || route == '/signUp') {
        print("Admin already logged in, redirecting to adminDashboard.");
        return const RouteSettings(name: '/adminDashboard');
      }
      if (![
        '/adminDashboard',
        '/adminJobs',
        '/adminEditDetails',
        '/adminCustomersList',
        '/adminChangePassword'
      ].contains(route)) {
        print("Admin cannot access this page. Redirecting to adminDashboard.");
        return const RouteSettings(name: '/adminDashboard');
      }
      return null; // Allow navigation to admin routes
    }

    if (userController.role.value == 'user') {
      if (route == '/signIn' || route == '/signUp') {
        print("Admin already logged in, redirecting to adminDashboard.");
        return const RouteSettings(name: '/userJobs');
      }

      if (![
        '/userChangePassword',
        '/userForgetPassword',
        '/userJobs',
        '/userJobDetailsPage',
        '/userProfileDetails'
      ].contains(route)) {
        print("User cannot access this page. Redirecting to Users Job Page.");
        return const RouteSettings(name: '/userJobs');
      }
      return null; // Allow navigation to user routes
    }

    print("No redirection needed.");
    return null; // Allow navigation if all checks pass
  }
}
