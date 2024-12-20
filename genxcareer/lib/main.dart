import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/splash_screen.dart';

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

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GenX Career',
      home: Scaffold(
        body: SafeArea(child: SplashScreen()),
      ),
    );
  }
}
