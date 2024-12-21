import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:genxcareer/controller/user_controller.dart';

Future<Map<String, dynamic>> firebaseSignUp(
    String email, String password) async {
  final auth = FirebaseAuth.instance;

  try {
    final UserCredential userCredential =
        await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final User? checkUser = userCredential.user;

    // print("Email: ${checkUser?.email}");
    // print("uid: ${checkUser?.uid}");

    if (checkUser != null) {
      return {
        "status": true,
        "message": "Registration successful!",
        "email": checkUser,
        "uid": checkUser.uid,
      };
    } else {
      return {
        "status": false,
        "message": "User registration failed.",
        "email": null,
        "uid": null,
      };
    }
  } on FirebaseAuthException catch (e) {
    String errorMessage;
    if (e.code == "weak-password") {
      errorMessage = "Password is too weak.";
    } else if (e.code == "email-already-in-use") {
      errorMessage = "This email is already in use.";
    } else {
      errorMessage = "Error: ${e.message}";
    }

    return {
      "status": false,
      "message": errorMessage,
      "email": null,
      "uid": null
    };
  } catch (e) {
    String errorMessage = "An unexpected error occurred: ${e.toString()}";

    return {
      "status": false,
      "message": errorMessage,
      "email": null,
      "uid": null
    };
  }
}

Future<Map<String, dynamic>> firebaseSignIn(
    String email, String password) async {
  final auth = FirebaseAuth.instance;
  final userController = Get.find<UserController>();

  try {
    final UserCredential userCredential =
        await auth.signInWithEmailAndPassword(email: email, password: password);

    final User? checkUser = userCredential.user;

    if (checkUser != null) {
      if (!checkUser.emailVerified) {
        return {
          "status": false,
          "message": "Please verify your email before logging in.",
          "email": checkUser.email,
          "uid": checkUser.uid,
        };
      }

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: checkUser.email)
          .get();

      if (doc.docs.isNotEmpty) {
        final userDoc = doc.docs.first;
        String? role = userDoc.data()['role'];
        String? name = userDoc.data()['name'];
        String? idToken = await checkUser.getIdToken();
        final decodedToken = await checkUser.getIdTokenResult();
        final expDate = DateTime.fromMillisecondsSinceEpoch(
            decodedToken.expirationTime!.millisecondsSinceEpoch);
        final bool isTokenExpired = DateTime.now().isAfter(expDate);

        // Store the user data using GetX
        userController.setUserData(
            idToken ?? '', checkUser.email ?? '', role ?? '', isTokenExpired);

        // print("Token Expiry Date: $expDate");
        // print("Is Token Expired? $isTokenExpired");
        // print("Check User: $checkUser");
        // print("idToken: $idToken");

        return {
          "status": true,
          "message": "Login successful.",
          "email": checkUser.email,
          "uid": checkUser.uid,
          "token": idToken ?? '',
          "isTokenExpired": isTokenExpired,
          "tokenExpDate": expDate,
          "role": role ?? '',
          "name": name ?? '',
        };
      } else {
        return {
          "status": false,
          "message": "No user data found in the database.",
          "email": checkUser.email,
          "uid": checkUser.uid,
        };
      }
    } else {
      return {
        "status": false,
        "message": "User not found.",
        "email": null,
        "uid": null,
      };
    }
  } on FirebaseAuthException catch (e) {
    String errorMessage;
    if (e.code == "user-not-found") {
      errorMessage = "No user found for that email.";
    } else if (e.code == "wrong-password") {
      errorMessage = "Incorrect password.";
    } else {
      errorMessage = "Error: ${e.message}";
    }

    return {
      "status": false,
      "message": errorMessage,
      "email": null,
      "uid": null,
    };
  } catch (e) {
    String errorMessage = "An unexpected error occurred: ${e.toString()}";

    return {
      "status": false,
      "message": errorMessage,
      "email": null,
      "uid": null,
    };
  }
}
