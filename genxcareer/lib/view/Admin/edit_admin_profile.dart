import 'package:flutter/material.dart';
import 'package:genxcareer/controller/user_controller.dart';
import 'package:genxcareer/routes/app_routes.dart';
import 'package:genxcareer/services/user_service.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AdminDetailPage extends StatefulWidget {
  const AdminDetailPage({super.key});

  @override
  _AdminDetailPageState createState() => _AdminDetailPageState();
}

class _AdminDetailPageState extends State<AdminDetailPage> {
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
        
        final String fileExtension =
            pickedFile.path.split('.').last.toLowerCase();
        const List<String> allowedExtensions = ['jpg', 'jpeg', 'png'];

        if (allowedExtensions.contains(fileExtension)) {
          setState(() {
            _selectedImage = pickedFile;
          });
        } else {
          
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
          
          Positioned.fill(
            child: Container(
              color: Color(0xFF40189D), 
            ),
          ),
          
          Positioned(
            top: 230, 
            left: 0,
            right: 0,
            bottom: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft:
                    Radius.circular(30), 
                topRight:
                    Radius.circular(30), 
              ),
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 100), 
                  child: SingleChildScrollView(
                    
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32.0),
                        ),
                        const SizedBox(height: 24),
                       
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
                        
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0),
                          child: ElevatedButton(
                            onPressed: () {
                              updateProfile(_selectedImage?.path ?? '');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 66, 2,
                                  122), 
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
          
          Positioned(
            top: 160, 
            left: MediaQuery.of(context).size.width / 2 -
                60, 
            child: GestureDetector(
              onTap: _pickImage,
              child: Stack(
                clipBehavior: Clip.none, 
                children: [
                  
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

                  
                  Positioned(
                    bottom:
                        -10, 
                    right: 2, 
                    child: GestureDetector(
                      onTap: _pickImage, 
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

          Positioned(
            top: 50, 
            left: 20, 
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 34, 
                  ),
                  onPressed: () {
                    Get.offAllNamed(AppRoutes.adminDashboard);
                  },
                ),
                const SizedBox(
                    width: 20), 
                const Text(
                  'Edit Admin Profile',
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
