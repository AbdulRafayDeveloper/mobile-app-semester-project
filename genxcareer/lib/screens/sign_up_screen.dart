import 'package:flutter/material.dart';
import 'package:genxcareer/screens/sign_in_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool emailError = false;
  bool passwordError = false;
  String? emailErrorText = null;
  String? paswordErrorText = null;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

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


  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/loginBackground.png'), // Your background image
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
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: _selectedImage != null
                              ? FileImage(_selectedImage!)
                              : null,
                          child: _selectedImage == null
                              ? const Icon(
                                  Icons.person,
                                  size: 50,
                                  color: Colors.grey,
                                )
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 42,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: Colors.white, width: 1),
                      ),
                      child: TextField(
                        controller: emailController,
                        style: const TextStyle(color: Colors.white),
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
                          filled: false,
                          errorText: emailError ? emailErrorText : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                       height: 42,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white, width: 1),
                      ),
                      child: TextField(
                        controller: passwordController,
                        style: const TextStyle(color: Colors.white),
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
                          filled: false,
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
                                backgroundColor: Color(0xFF9866C7),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              onPressed: validateAndSignIn,
                              child: const Text('Register',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already Registered User?",
                              style: TextStyle(fontSize: 13, color: Colors.white)),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> SignInScreen()));
                              });
                            },
                            child: const Text(
                              'Login Now!',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
