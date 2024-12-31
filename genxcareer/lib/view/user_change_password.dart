import 'package:flutter/material.dart';
import 'package:genxcareer/routes/app_routes.dart';
import 'package:genxcareer/services/user_service.dart';
import 'package:get/get.dart';

class UserPasswordPage extends StatelessWidget {
  const UserPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: PasswordScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PasswordScreen extends StatefulWidget {
  const PasswordScreen({Key? key}) : super(key: key);

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _showCurrentPassword = false;
  bool _showNewPassword = false;
  bool _showReTypeNewPassword = false;

  void _changePassword() async {
    if (_formKey.currentState?.validate() ?? false) {
      String currentPassword = _currentPasswordController.text.trim();
      String newPassword = _newPasswordController.text.trim();
      String confirmPassword = _confirmPasswordController.text.trim();

      var response = await UserApis()
          .changePassword(currentPassword, newPassword, confirmPassword);

      if (response['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password Changed Successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 4),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${response['message']}'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
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
                        Get.offAllNamed(AppRoutes.userJobs);
                      },
                    ),
                    const Text(
                      'Go Back',
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

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

                _buildPasswordField(
                  controller: _currentPasswordController,
                  label: 'Current Password',
                  showPassword: _showCurrentPassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Current Password cannot be empty';
                    }
                    return null;
                  },
                  onVisibilityPressed: () {
                    setState(() {
                      _showCurrentPassword = !_showCurrentPassword;
                    });
                  },
                ),
                const SizedBox(height: 20),

                _buildPasswordField(
                  controller: _newPasswordController,
                  label: 'New Password',
                  showPassword: _showNewPassword,
                  onVisibilityPressed: () {
                    setState(() {
                      _showNewPassword = !_showNewPassword;
                    });
                  },
                ),
                const SizedBox(height: 20),

                _buildPasswordField(
                  controller: _confirmPasswordController,
                  label: 'Re-Type New Password',
                  showPassword: _showReTypeNewPassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Confirm Password cannot be empty';
                    }
                    if (value != _newPasswordController.text) {
                      return 'Password and Confirm Password must match';
                    }
                    return null;
                  },
                  onVisibilityPressed: () {
                    setState(() {
                      _showReTypeNewPassword = !_showReTypeNewPassword;
                    });
                  },
                ),
                const SizedBox(height: 30),

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

  
  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool showPassword,
    String? Function(String?)? validator,
    required VoidCallback onVisibilityPressed,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !showPassword,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            showPassword ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: onVisibilityPressed,
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
