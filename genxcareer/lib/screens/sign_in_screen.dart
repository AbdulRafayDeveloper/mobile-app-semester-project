import 'package:flutter/material.dart';
import 'package:genxcareer/screens/Admin/jobs.dart';
import 'package:genxcareer/screens/sign_up_screen.dart';
import 'package:genxcareer/screens/jobs_screen.dart'; // Import JobsScreen

class SignInScreen extends StatefulWidget {
  SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool emailError = false;
  bool passwordError = false;
  String? emailErrorText = null;
  String? paswordErrorText = null;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void validateAndSignIn() {
    final email = emailController.text.trim();
    final password = passwordController.text;

    // Validate email
    if (email.isEmpty) {
      setState(() {
        emailError = true;
        emailErrorText = "Email/Username cannot be empty.";
      });
      return;
    } else if (email.contains(' ')) {
      setState(() {
        emailError = true;
        emailErrorText = "Email/Username cannot contain spaces.";
      });
      return;
    } else {
      setState(() {
        emailError = false;
        emailErrorText = null;
      });
    }

    // Validate password
    if (password.isEmpty) {
      setState(() {
        passwordError = true;
        paswordErrorText = "Password cannot be empty.";
      });
      return;
    } else {
      setState(() {
        passwordError = false;
        paswordErrorText = null;
      });
    }

    // Simulate successful sign-in and navigate to JobsScreen
    if (!emailError && !passwordError) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Jobs(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/loginBackground.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: const Image(
                        image: AssetImage('assets/translogo.png'),
                        width: 200,
                        height: 200,
                      ),
                    ),
                    Container(
                      height: 42,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextField(
                        controller: emailController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.email,
                            color: Colors.white,
                          ),
                          labelText: "Email",
                          labelStyle: const TextStyle(
                            color: Colors.white,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(color: Colors.white, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(color: Colors.white, width: 1),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(color: Colors.red, width: 1),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: const BorderSide(color: Colors.red, width: 1),
                          ),
                          filled: true,
                          fillColor: Colors.transparent,
                          errorText: emailError ? emailErrorText : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 42,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: TextField(
                        controller: passwordController,
                        obscureText: true,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.password,
                            color: Colors.white,
                          ),
                          labelText: "Password",
                          labelStyle: const TextStyle(
                            color: Colors.white,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: const BorderSide(color: Colors.white, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: const BorderSide(color: Colors.white, width: 1),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: const BorderSide(color: Colors.red, width: 1),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: const BorderSide(color: Colors.red, width: 1),
                          ),
                          filled: true,
                          fillColor: Colors.transparent,
                          errorText: passwordError ? paswordErrorText : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 38,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(133, 199, 168, 238),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              onPressed: validateAndSignIn,
                              child: const Text(
                                'Log In',
                                style: TextStyle(fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Not a Registered User ?",
                            style: TextStyle(fontSize: 13, color: Colors.white),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) => SignUpScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'Register Now!',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
