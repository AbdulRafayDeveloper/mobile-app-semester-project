import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:genxcareer/controller/user_controller.dart';
import 'package:genxcareer/routes/app_routes.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  final userController = Get.find<UserController>();
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Set the navigation bar and status bar color
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color(0xFF40189D), // Status bar color
      statusBarIconBrightness: Brightness.light, // Status bar icon color
      systemNavigationBarColor: Color(0xFF40189D), // Navigation bar color
      systemNavigationBarIconBrightness: Brightness.light, // Nav bar icon color
    ));

    // Initialize the animation controller
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    // Fade animation
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    // Scale animation
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutBack,
      ),
    );

    // Start the animation
    _controller.forward();
    _checkUserAuthentication();
  }

  // Separate async method to handle user authentication
  Future<void> _checkUserAuthentication() async {
    // Get the user from FirebaseAuth
    User? checkUser = await FirebaseAuth.instance.currentUser;

    print("Splash Screen checkUser: $checkUser");

    // Check if the user is authenticated
    if (checkUser != null) {
      if (!checkUser.emailVerified) {
        return;
      }

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: checkUser.email)
          .get();

      if (doc.docs.isNotEmpty) {
        final userDoc = doc.docs.first;
        String? role = userDoc.data()['role'];
        String? provider = userDoc.data()['provider'];
        String? idToken = await checkUser.getIdToken();
        final decodedToken = await checkUser.getIdTokenResult();
        final expDate = DateTime.fromMillisecondsSinceEpoch(
            decodedToken.expirationTime!.millisecondsSinceEpoch);
        final bool isTokenExpired = DateTime.now().isAfter(expDate);

        // Store the user data using GetX
        userController.setUserData(idToken ?? '', checkUser.email ?? '',
            role ?? '', provider ?? "email", isTokenExpired);

        print("Token Expiry Date: $expDate");
        print("Is Token Expired? $isTokenExpired");
        print("Check User: $checkUser");
        print("idToken: $idToken");
        print("provider: $provider");
      } else {
        print("Please Login to apply for Jobs or as an administrator");
      }
    } else {
      print("Please Login to apply for Jobs or as an administrator");
    }

    // Delay for 3 seconds before checking the user role and navigating
    Future.delayed(const Duration(seconds: 1), () {
      if (userController.role.value == "admin") {
        Get.offAllNamed(AppRoutes.adminDashboard);
      } else {
        Get.offAllNamed(AppRoutes.userJobs);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF40189D), // Background color
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _scaleAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: const Image(
                    image: AssetImage('assets/NX.png'),
                    width: 300,
                    height: 300,
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
