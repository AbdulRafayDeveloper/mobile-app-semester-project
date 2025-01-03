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

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color(0xFF40189D),
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF40189D),
      systemNavigationBarIconBrightness: Brightness.light,
    ));

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutBack,
      ),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(seconds: 1), () {
          _checkUserAuthentication();
        });
      }
    });

    _controller.forward();
  }

  Future<void> _checkUserAuthentication() async {
    User? checkUser = await FirebaseAuth.instance.currentUser;

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

        userController.setUserData(idToken ?? '', checkUser.email ?? '',
            role ?? '', provider ?? "email", isTokenExpired);
      } else {}
    }

    Future.delayed(const Duration(seconds: 2), () {
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
          color: Color(0xFF40189D),
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
