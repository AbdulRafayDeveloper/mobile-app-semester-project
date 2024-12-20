import 'package:flutter/material.dart';
import 'package:genxcareer/screens/Admin/dashboard.dart';
import 'package:genxcareer/screens/Admin/jobs.dart';
import 'package:genxcareer/screens/forget_password.dart';
import 'package:genxcareer/screens/sign_up_screen.dart';
import 'package:genxcareer/screens/jobs_screen.dart';
import 'package:flutter/gestures.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SignInScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _showPassword = false;

  void login() {
    if (_formKey.currentState?.validate() ?? false) {
      // Valid inputs
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login Successful!'),
        ),
      );
      Navigator.push(context, MaterialPageRoute(builder: (context)=> Dashboard()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F3FF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back Button and Title
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => JobsScreen()),
                          );
                        },
                      ),
                      const Text(
                        'Go Back to Jobs',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // Sign In Title
                  const Text(
                    'Sign In',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Please sign in to your registered account',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 30),

                  // Email TextField
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email cannot be empty';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Password TextField
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_showPassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _showPassword ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _showPassword = !_showPassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password cannot be empty';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ForgetPasswordPage()),
                        );
                      },
                      child: const Text(
                        'Forgot your password?',
                        style: TextStyle(fontSize: 14, color: Color(0xFF40189D)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),

                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF40189D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: login,
                      child: const Text(
                        'SIGN IN',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Align(
                    alignment: Alignment.center,
                    child: RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: const TextStyle(fontSize: 14, color: Colors.black),
                        children: [
                          TextSpan(
                            text: 'Sign up',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF40189D),
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => SignUpScreen()),
                                );
                              },
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Or Sign In With
                  const Center(
                    child: Text(
                      'Or sign in with',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Google Sign-In Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: const BorderSide(
                          color: Color(0xFF40189D),
                          width: 0.5,
                        ),
                      ),
                      onPressed: login,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/google-removebg-preview.png', height: 24),
                          const SizedBox(width: 20),
                          const Text(
                            'Sign In with Google',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Facebook Sign-In Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: const BorderSide(
                          color: Color(0xFF40189D),
                          width: 0.5,
                        ),
                      ),
                      onPressed: login,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/facebook-removebg-preview.png', height: 24),
                          const SizedBox(width: 10),
                          const Text(
                            'Sign In with Facebook',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
