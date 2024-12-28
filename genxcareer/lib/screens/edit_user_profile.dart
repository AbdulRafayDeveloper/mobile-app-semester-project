import 'package:flutter/material.dart';
import 'package:genxcareer/controller/user_controller.dart';
import 'package:genxcareer/routes/app_routes.dart';
import 'package:genxcareer/services/user_service.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UserDetailPage extends StatefulWidget {
  const UserDetailPage({super.key});

  @override
  _UserDetailPageState createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  final userStates = Get.find<UserController>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String? _profileUrl;

  XFile? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final result = await UserApis().getOneUser(userStates.email.value);
      if (result['status'] == 'success') {
        final data = result['data'];
        setState(() {
          _nameController.text = data['name'];
          _emailController.text = data['email'];
          _profileUrl = data['profileUrl'];
        });
      } else {
        Get.snackbar(
          'Error',
          result['message'],
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile =
          await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        // Validate the file type
        final String fileExtension =
            pickedFile.path.split('.').last.toLowerCase();
        const List<String> allowedExtensions = ['jpg', 'jpeg', 'png'];

        if (allowedExtensions.contains(fileExtension)) {
          setState(() {
            _selectedImage = pickedFile;
          });
        } else {
          // Show error if file type is not allowed
          Get.snackbar(
            'Invalid File',
            'Please select a valid image file (JPG, JPEG, or PNG).',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      }
    } catch (e) {
      // Handle errors during image selection
      Get.snackbar(
        'Error',
        'An unexpected error occurred while selecting an image.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> updateProfile(String imagePath) async {
    try {
      final String finalImagePath =
          imagePath.isNotEmpty ? imagePath : _profileUrl ?? '';

      final result = await UserApis().updateUserByEmail(
        userStates.email.value,
        finalImagePath,
        _nameController.text,
      );

      if (result['status'] == 'success') {
        setState(() {
          _profileUrl = finalImagePath;
        });
        Get.snackbar(
          'Success',
          result['message'],
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Error',
          result['message'],
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image (outside area)
          Positioned.fill(
            child: Container(
              color: Color(0xFF40189D), // Use any color you prefer
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
                topLeft:
                    Radius.circular(30), // Adjust the top-left corner radius
                topRight:
                    Radius.circular(30), // Adjust the top-right corner radius
              ),
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 100), // Adjust to make room for avatar
                  child: SingleChildScrollView(
                    // Make the content scrollable
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
                                    focusColor: Colors.purple),
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: _emailController,
                                decoration: const InputDecoration(
                                  labelText: 'Email',
                                  border: OutlineInputBorder(),
                                ),
                                enabled: false,
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Save Changes Button
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0),
                          child: ElevatedButton(
                            onPressed: () {
                              updateProfile(_selectedImage?.path ?? '');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 66, 2,
                                  122), // Set the background color to purple
                            ),
                            child: const Text(
                              'Save Changes',
                              style: TextStyle(color: Colors.white),
                            ),
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
            left: MediaQuery.of(context).size.width / 2 -
                60, // Center horizontally
            child: GestureDetector(
              onTap: _pickImage, // Pick image on avatar tap
              child: Stack(
                clipBehavior: Clip.none, // Ensure the icon doesn't clip
                children: [
                  // Circular Avatar
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: _selectedImage != null
                        ? FileImage(File(_selectedImage!.path))
                        : (_profileUrl != null &&
                                _profileUrl!.startsWith('/data'))
                            ? FileImage(File(_profileUrl!))
                            : const AssetImage('assets/default_avatar.png')
                                as ImageProvider,
                  ),

                  // Edit Pencil Icon
                  Positioned(
                    bottom:
                        -10, // Position the pencil slightly outside the avatar
                    right: 2, // Position it on the right side
                    child: GestureDetector(
                      onTap: _pickImage, // Pick image on pencil icon tap
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Color.fromARGB(255, 80, 2, 139),
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
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 34, // Adjust size of the arrow
                  ),
                  onPressed: () {
                    Get.offAllNamed(AppRoutes.userJobs);
                  },
                ),
                const SizedBox(
                    width: 20), // Add spacing between the icon and the text
                const Text(
                  'Edit User Profile',
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
