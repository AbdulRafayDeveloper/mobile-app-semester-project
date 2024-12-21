import 'package:genxcareer/middleware/auth_middleware.dart';
import 'package:genxcareer/screens/Admin/admin_update.dart';
import 'package:genxcareer/screens/Admin/change_password.dart';
import 'package:genxcareer/screens/Admin/dashboard.dart';
import 'package:genxcareer/screens/Admin/jobs.dart';
import 'package:genxcareer/screens/Admin/users.dart';
import 'package:genxcareer/screens/change_password.dart';
import 'package:genxcareer/screens/forget_password.dart';
import 'package:genxcareer/screens/jobDetails.dart';
import 'package:genxcareer/screens/jobs_screen.dart';
import 'package:genxcareer/screens/sign_in_screen.dart';
import 'package:genxcareer/screens/sign_up_screen.dart';
import 'package:genxcareer/screens/splash_screen.dart';
import 'package:genxcareer/screens/users_details.dart';
import 'package:get/get.dart';

class AppRoutes {
  // common routes
  static const splashScreen = '/splashScreen';
  static const forgetPassword = '/forgetPassword';
  static const signIn = '/signIn';
  static const signUp = '/signUp';

  // admin routes
  static const adminDashboard = '/adminDashboard';
  static const adminJobs = '/adminJobs';
  static const adminEditDetails = '/adminEditDetails';
  static const adminCustomersList = '/adminCustomersList';
  static const adminChangePassword = '/adminChangePassword';
  // user routes
  static const userChangePassword = '/userChangePassword';
  static const userForgetPassword = '/userForgetPassword';
  static const userJobs = '/userJobs';
  static const userJobDetailsPage = '/userJobDetailsPage';
  static const userProfileDetails = '/userProfileDetails';

  static List<GetPage> pages = [
    GetPage(name: splashScreen, page: () => SplashScreen()),
    GetPage(
        name: signIn,
        page: () => SignInScreen(),
        middlewares: [AuthMiddleware()]),
    GetPage(
        name: signUp,
        page: () => SignUpScreen(),
        middlewares: [AuthMiddleware()]),
    GetPage(name: forgetPassword, page: () => ForgetPasswordPage()),

    // admin
    GetPage(
        name: adminDashboard,
        page: () => Dashboard(),
        middlewares: [AuthMiddleware()]),
    GetPage(
        name: adminJobs, page: () => Jobs(), middlewares: [AuthMiddleware()]),
    GetPage(
        name: adminEditDetails,
        page: () => AdminDetailPage(),
        middlewares: [AuthMiddleware()]),
    GetPage(
        name: adminCustomersList,
        page: () => Users(),
        middlewares: [AuthMiddleware()]),
    GetPage(
        name: adminChangePassword,
        page: () => AdminPasswordPage(),
        middlewares: [AuthMiddleware()]),

    // users
    GetPage(
        name: userChangePassword,
        page: () => UserPasswordPage(),
        middlewares: [AuthMiddleware()]),
    GetPage(
        name: userForgetPassword,
        page: () => ForgetPasswordPage(),
        middlewares: [AuthMiddleware()]),
    GetPage(name: userJobs, page: () => JobsScreen()),
    GetPage(
        name: AppRoutes.userJobDetailsPage,
        page: () => JobDetailsPage(job: Get.arguments['job'])),

    GetPage(
        name: userProfileDetails,
        page: () => UserDetailPage(),
        middlewares: [AuthMiddleware()]),
  ];
}
