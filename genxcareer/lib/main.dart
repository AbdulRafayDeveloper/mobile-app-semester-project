import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:genxcareer/controller/user_controller.dart';
import 'package:genxcareer/routes/app_routes.dart';
import 'package:genxcareer/services/jobs_service.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (kIsWeb) {
      await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: "AIzaSyDZV8hMrLXJQ0FPinbWWHBFnJaairX8Y2E",
              authDomain: "genx-career.firebaseapp.com",
              projectId: "genx-career",
              storageBucket: "genx-career.firebasestorage.app",
              messagingSenderId: "360584986024",
              appId: "1:360584986024:web:8b008565bde705b150719d"));
    } else {
      await Firebase.initializeApp();
    }
    debugPrint("🔥 Firebase successfully initialized!");
  } catch (e) {
    debugPrint("❌ Firebase initialization failed: $e");
  }

  Get.put(UserController());
  runApp(const MyApp());
  startJobFetchingTask();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GenX Career',
      initialRoute: AppRoutes.splashScreen,
      getPages: AppRoutes.pages,
    );
  }
}

void startJobFetchingTask() {
  const duration = Duration(minutes: 60);
  Timer.periodic(duration, (Timer timer) async {
    try {
      print("⏳ Fetching jobs from the API...");
      await JobsApis().fetchAndSaveJobs();
      print("✅ Timer: Jobs fetched and saved successfully.");
    } catch (e) {
      print("❌ Error during job fetching: $e");
    }

    print(
        "🔁 Timer execution cycle completed. Waiting for the next interval...");
  });
}
