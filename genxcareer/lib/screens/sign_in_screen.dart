import 'package:flutter/material.dart';
import 'package:genxcareer/screens/sign_up_screen.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Container(
        decoration: const BoxDecoration(color: Colors.white),
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
                      image: AssetImage('assets/logo2.png'),
                      width: 150,
                      height: 150,
                    ),
                  ),
                  Center(
                    child: const Text(
                      'Log in to your account',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFcb00f5),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Container(
                    height: 42,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.email,
                          color: Color.fromARGB(255, 188, 187, 187),
                        ),
                        labelText: "Email",
                        labelStyle: const TextStyle(
                          color: Color.fromARGB(255, 188, 187, 187),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        errorText: emailError ? emailErrorText : null,
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 42,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.password,
                          color: Color.fromARGB(255, 188, 187, 187),
                        ),
                        labelText: "Password",
                        labelStyle: const TextStyle(
                          color: Color.fromARGB(255, 188, 187, 187),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        errorText: passwordError ? paswordErrorText : null,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 38,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFcb00f5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              onPressed: () {
                                validateAndSignIn();
                              },
                              child: const Text('Log In',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white))),
                        ),
                      ),
                    ],
                  ),
                  // const SizedBox(
                  //   height: 15,
                  // ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Not a Registered User ?",
                            style: TextStyle(fontSize: 13)),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          SignUpScreen()));
                            },
                            child: const Text('Register Now!',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFFcb00f5),
                                ))),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                ]),
          ),
        )),
      )),
    );
  }
}
