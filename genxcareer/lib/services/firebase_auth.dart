import 'package:firebase_auth/firebase_auth.dart';
import 'package:genxcareer/models/user_model.dart';
import 'package:genxcareer/services/user_service.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:genxcareer/controller/user_controller.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

        userController.setUserData(idToken ?? '', checkUser.email ?? '',
            role ?? '', "email", isTokenExpired);

        await FirebaseFirestore.instance
            .collection('users')
            .doc(checkUser.uid)
            .update({
          'provider': 'email',
        });

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
    } else if (e.code == "invalid-credentials" ||
        e.message?.contains("The supplied auth credential") == true) {
      errorMessage = "Your credentials are incorrect.";
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

Future<Map<String, dynamic>?> signInWithGoogle() async {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final userController = Get.find<UserController>();
  final userApis = UserApis();

  try {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null;

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential userCredential =
        await _auth.signInWithCredential(credential);
    final User? user = userCredential.user;

    if (user == null) {
      return {
        "status": false,
        "message": "Sign-in failed, no user found.",
        "email": null,
        "uid": null,
      };
    }

    if (!user.emailVerified) {
      return {
        "status": false,
        "message": "Please verify your email before logging in.",
        "email": user.email,
        "uid": user.uid,
      };
    }

    final doc = await _firestore.collection('users').doc(user.uid).get();

    if (!doc.exists) {
      try {
        UserModel userModel = UserModel(
          uid: user.uid,
          name: googleUser.displayName ?? "Anonymous",
          email: googleUser.email,
          role: "user",
          provider: "google",
          profileUrl: "",
          createdAt: DateTime.now(),
        );

        final savedUser = await userApis.addUser(userModel);

        if (savedUser['status'] == false) {
          return {
            "status": false,
            "message": "Failed to create user in the database.",
            "email": user.email,
            "uid": user.uid,
          };
        }
      } catch (e) {
        return {
          "status": false,
          "message": "An error occurred while creating user.",
          "email": user.email,
          "uid": user.uid,
        };
      }
    } else {
      try {
        await _firestore.collection('users').doc(user.uid).update({
          'provider': 'google',
        });
      } catch (e) {
        print("Error updating user provider: $e");
      }
    }

    final userDoc = doc.data()!;
    String? role = userDoc['role'];
    String? name = userDoc['name'];
    String? idToken = await user.getIdToken();
    final decodedToken = await user.getIdTokenResult();
    final expDate = DateTime.fromMillisecondsSinceEpoch(
        decodedToken.expirationTime!.millisecondsSinceEpoch);
    final bool isTokenExpired = DateTime.now().isAfter(expDate);

    userController.setUserData(idToken ?? '', user.email ?? '', role ?? 'user',
        "google", isTokenExpired);

    return {
      "status": true,
      "message": "Login successful.",
      "email": user.email,
      "uid": user.uid,
      "token": idToken ?? '',
      "isTokenExpired": isTokenExpired,
      "tokenExpDate": expDate,
      "role": role ?? 'user',
      "name": name ?? '',
    };
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
    return {
      "status": false,
      "message": "An unexpected error occurred.",
      "email": null,
      "uid": null,
    };
  }
}
