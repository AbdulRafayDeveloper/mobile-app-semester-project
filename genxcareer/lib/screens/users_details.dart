import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // Import to use File

class UserDetailPage extends StatefulWidget {
  const UserDetailPage({super.key});

  @override
  _UserDetailPageState createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  // List to hold the account details (Name, Email, Password)
  List<String> accountDetails = ['John Doe', 'johndoe@example.com', 'password123'];

  // Variable to store the selected image
  XFile? _selectedImage;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Initialize the controllers with the current values from the list
    _nameController.text = accountDetails[0];
    _emailController.text = accountDetails[1];
    _passwordController.text = accountDetails[2];
  }

  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = pickedFile; // Update the selected image
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image (outside area)
          Positioned.fill(
            child: Image.asset(
              'assets/HD-wallpaper-back-to-it-background-purple-solid-thumbnail.jpg', // Replace with your image path
              fit: BoxFit.cover,
            ),
          ),
          // White Container with Rounded Top
          Positioned(
            top: 230, // Move the white container down (adjusted)
            left: 0,
            right: 0,
            bottom: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30), // Adjust the top-left corner radius
                topRight: Radius.circular(30), // Adjust the top-right corner radius
              ),
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.only(top: 100), // Adjust to make room for avatar
                  child: SingleChildScrollView( // Make the content scrollable
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32.0),
                        ),
                        const SizedBox(height: 24),
                        // Form for name, email, and password
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0),
                          child: Column(
                            children: [
                              TextField(
                                controller: _nameController,
                                decoration: const InputDecoration(
                                  labelText: 'Name',
                                  border: OutlineInputBorder(),
                                  focusColor: Colors.purple
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    accountDetails[0] = value; // Update name in the list
                                  });
                                },
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: _emailController,
                                decoration: const InputDecoration(
                                  labelText: 'Email',
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    accountDetails[1] = value; // Update email in the list
                                  });
                                },
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: _passwordController,
                                obscureText: !_isPasswordVisible,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  border: const OutlineInputBorder(),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isPasswordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isPasswordVisible = !_isPasswordVisible;
                                      });
                                    },
                                  ),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    accountDetails[2] = value; // Update password in the list
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Save Changes Button
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0),
                          child: ElevatedButton(
                            onPressed: () {
                              // Save changes action here
                              final name = _nameController.text;
                              final email = _emailController.text;
                              final password = _passwordController.text;
                              print("Name: $name, Email: $email, Password: $password");
                              // Perform save action (like updating the database)
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 66, 2, 122), // Set the background color to purple
                            ),
                            child: const Text('Save Changes', style: TextStyle(color: Colors.white),),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Circular Avatar breaking outside the white area
          Positioned(
            top: 160, // Move the avatar down to be half inside and half outside
            left: MediaQuery.of(context).size.width / 2 - 60, // Center horizontally
            child: GestureDetector(
              onTap: _pickImage, // Pick image on avatar tap
              child: Stack(
                clipBehavior: Clip.none, // Ensure the icon doesn't clip
                children: [
                  // Circular Avatar
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: _selectedImage == null
                        ? NetworkImage(
                            'https://plus.unsplash.com/premium_photo-1678197937465-bdbc4ed95815?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cGVyc29ufGVufDB8fDB8fHww')
                        : FileImage(File(_selectedImage!.path)), // Show selected image if available
                  ),
                  // Edit Pencil Icon
                  Positioned(
                    bottom: -10, // Position the pencil slightly outside the avatar
                    right: 2,  // Position it on the right side
                    child: GestureDetector(
                      onTap: _pickImage, // Pick image on pencil icon tap
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.edit,
                          color: const Color.fromARGB(255, 80, 2, 139),
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Arrowhead and Title in the outer white area
          Positioned(
            top: 50, // Position the arrow and title near the top
            left: 20, // Add some padding from the left side of the screen
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 34, // Adjust size of the arrow
                  ),
                  onPressed: () {
                    Navigator.pop(context); // This will navigate back to the previous screen
                  },
                ),
                SizedBox(width: 20), // Add spacing between the icon and the text
                Text(
                  'User Settings', // Adjust text as needed
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
