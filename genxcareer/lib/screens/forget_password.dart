import 'package:flutter/material.dart';
import 'package:genxcareer/screens/jobs_screen.dart';
import 'package:genxcareer/screens/sign_in_screen.dart';

class ForgetPasswordPage extends StatelessWidget {
  const ForgetPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ForgetPasswordScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _showPassword = false;

  // Handle password change
  void _changePassword() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password Changed Successfully!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F3FF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => const JobsScreen()));
                      },
                    ),
                    const Text(
                      'Go Back to Login',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // Title
                const Text(
                  'Change Password',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Your password should be at least 6 characters long',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 30),

                // Current Password
                _buildPasswordField(
                  controller: _currentPasswordController,
                  label: 'Current Password',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Current Password cannot be empty';
                    }
                    return null; // Add additional validation if needed
                  },
                ),
                const SizedBox(height: 20),

                // New Password
                _buildPasswordField(
                  controller: _newPasswordController,
                  label: 'New Password',
                ),
                const SizedBox(height: 20),

                // Confirm Password
                _buildPasswordField(
                  controller: _confirmPasswordController,
                  label: 'Re-Type New Password',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Confirm Password cannot be empty';
                    }
                    if (value != _newPasswordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),

                // Submit Button
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
                    onPressed: _changePassword,
                    child: const Text(
                      'Change Password',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Reusable Password Field Widget
  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !_showPassword,
      decoration: InputDecoration(
        labelText: label,
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
      validator: validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return '$label cannot be empty';
            }
            if (value.length < 6) {
              return '$label must be at least 6 characters';
            }
            return null;
          },
    );
  }
}
