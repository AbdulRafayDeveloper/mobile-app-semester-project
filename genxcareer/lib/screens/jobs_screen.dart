import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:genxcareer/controller/user_controller.dart';
import 'package:genxcareer/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class JobsScreen extends StatefulWidget {
  const JobsScreen({super.key});

  @override
  _JobsScreenState createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final userStates = Get.find<UserController>();
  bool isSearchFocused = false; // To track if the search bar is focused
  double minSalary = 30000; // Minimum salary default value
  double maxSalary = 100000; // Maximum salary default value
  DateTime? selectedDate; // Store the selected date
  List<Map<String, String>> jobs = []; // This will hold the jobs displayed
  bool isLoadingMore = false; // To manage the loading state

// Placeholder for job data
  final List<Map<String, String>> job = [
    {
      'company': 'Darkseer Studios',
      'title': 'Senior Software Engineer',
      'salary': '\$500 - \$1,000',
      'location': 'Medan, Indonesia',
      'logo':
          'https://res.cloudinary.com/vistaprint/images/c_scale,w_448,h_448,dpr_2/f_auto,q_auto/v1705580343/ideas-and-advice-prod/en-us/adidas/adidas.png?_i=AA',
      'description':
          'WLorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.',
      'jobType': 'Full-time'
    },
    {
      'company': 'Nextgen Corp',
      'title': 'Backend Developer',
      'salary': '\$800 - \$1,200',
      'location': 'Jakarta, Indonesia',
      'logo':
          'https://marketplace.canva.com/EAF7Nm6GMzo/1/0/1600w/canva-black-white-modern-concept-football-club-logo-3-nFuSBwgIA.jpg',
      'description':
          'Join our team to develop scalable backend solutions for our growing platform.',
      'jobType': 'Part-time'
    },
    {
      'company': 'Futura Labs',
      'title': 'Frontend Developer',
      'salary': '\$600 - \$900',
      'location': 'Bali, Indonesia',
      'logo':
          'https://www.logolounge.com/wp-content/uploads/2023/12/21954_438371-300x300.jpg',
      'description':
          'We are looking for a creative Frontend Developer to design user-friendly websites.',
      'jobType': 'Full-time'
    },
    {
      'company': 'Darkseer Studios',
      'title': 'Senior Software Engineer',
      'salary': '\$500 - \$1,000',
      'location': 'Medan, Indonesia',
      'logo':
          'https://res.cloudinary.com/vistaprint/images/c_scale,w_448,h_448,dpr_2/f_auto,q_auto/v1705580343/ideas-and-advice-prod/en-us/adidas/adidas.png?_i=AA',
      'description':
          'Lead the development of cutting-edge software solutions in a fast-paced environment.',
      'jobType': 'Contract'
    },
    {
      'company': 'Nextgen Corp',
      'title': 'Backend Developer',
      'salary': '\$800 - \$1,200',
      'location': 'Jakarta, Indonesia',
      'logo':
          'https://marketplace.canva.com/EAF7Nm6GMzo/1/0/1600w/canva-black-white-modern-concept-football-club-logo-3-nFuSBwgIA.jpg',
      'description':
          'Backend development and API integrations for high-traffic platforms.',
      'jobType': 'Full-time'
    },
    {
      'company': 'Futura Labs',
      'title': 'Frontend Developer',
      'salary': '\$600 - \$900',
      'location': 'Bali, Indonesia',
      'logo':
          'https://www.logolounge.com/wp-content/uploads/2023/12/21954_438371-300x300.jpg',
      'description':
          'Work closely with designers and other developers to create intuitive UI/UX experiences.',
      'jobType': 'Freelance'
    },
    {
      'company': 'Darkseer Studios',
      'title': 'Senior Software Engineer',
      'salary': '\$500 - \$1,000',
      'location': 'Medan, Indonesia',
      'logo':
          'https://res.cloudinary.com/vistaprint/images/c_scale,w_448,h_448,dpr_2/f_auto,q_auto/v1705580343/ideas-and-advice-prod/en-us/adidas/adidas.png?_i=AA',
      'description':
          'Help shape the future of the company by managing and guiding the tech team.',
      'jobType': 'Full-time'
    },
    {
      'company': 'Nextgen Corp',
      'title': 'Backend Developer',
      'salary': '\$800 - \$1,200',
      'location': 'Jakarta, Indonesia',
      'logo':
          'https://marketplace.canva.com/EAF7Nm6GMzo/1/0/1600w/canva-black-white-modern-concept-football-club-logo-3-nFuSBwgIA.jpg',
      'description':
          'Join us as we build scalable backend systems for our high-demand applications.',
      'jobType': 'Contract'
    },
    {
      'company': 'Futura Labs',
      'title': 'Frontend Developer',
      'salary': '\$600 - \$900',
      'location': 'Bali, Indonesia',
      'logo':
          'https://www.logolounge.com/wp-content/uploads/2023/12/21954_438371-300x300.jpg',
      'description':
          'Innovative Frontend Developer wanted to bring designs to life with modern JavaScript frameworks.',
      'jobType': 'Part-time'
    },
    {
      'company': 'Darkseer Studios',
      'title': 'Senior Software Engineer',
      'salary': '\$500 - \$1,000',
      'location': 'Medan, Indonesia',
      'logo':
          'https://res.cloudinary.com/vistaprint/images/c_scale,w_448,h_448,dpr_2/f_auto,q_auto/v1705580343/ideas-and-advice-prod/en-us/adidas/adidas.png?_i=AA',
      'description':
          'Take ownership of the software architecture and lead a diverse engineering team.',
      'jobType': 'Full-time'
    },
    {
      'company': 'Nextgen Corp',
      'title': 'Backend Developer',
      'salary': '\$800 - \$1,200',
      'location': 'Jakarta, Indonesia',
      'logo':
          'https://marketplace.canva.com/EAF7Nm6GMzo/1/0/1600w/canva-black-white-modern-concept-football-club-logo-3-nFuSBwgIA.jpg',
      'description':
          'Develop backend services and APIs with a focus on performance and scalability.',
      'jobType': 'Freelance'
    },
    {
      'company': 'Futura Labs',
      'title': 'Frontend Developer',
      'salary': '\$600 - \$900',
      'location': 'Bali, Indonesia',
      'logo':
          'https://www.logolounge.com/wp-content/uploads/2023/12/21954_438371-300x300.jpg',
      'description':
          'Collaborate with the design team to create pixel-perfect, responsive web pages.',
      'jobType': 'Part-time'
    },
  ];

  @override
  void initState() {
    super.initState();
    // Initially load first 5 jobs
    jobs.addAll(job.take(5));
    _checkUserAuthentication();
  }

  Future<void> _checkUserAuthentication() async {
    print("User isAuthenticated: ${userStates.isAuthenticated.value}");
    print("User role: ${userStates.role.value}");
    print("User token: ${userStates.token.value}");
    print("User tokenExpired: ${userStates.tokenExpired.value}");
  }

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; // Get screen size
    return Scaffold(
      backgroundColor: Colors.grey[100], // Light background color
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            if (isSearchFocused) {
              setState(() {
                isSearchFocused = false; // Reset when tapping outside
              });
            }
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Purple Area (Header)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: double.infinity,
                  height: isSearchFocused
                      ? 0
                      : size.height *
                          0.19, // Height reduces to 0 when search is focused
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF40189D),
                        Color.fromARGB(255, 111, 57, 238)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(60), // Increased roundness
                      bottomRight: Radius.circular(60),
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Centered Text
                      Positioned(
                        top: size.height *
                            0.05, // Adjust this value to center the text vertically
                        left: 30,
                        // right: 20,

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "GenX Career",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Your Job search partner",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Top-right icon (Popup Menu)
                      Positioned(
                        top: 10,
                        right: 10,
                        child: PopupMenuButton<String>(
                          icon: Container(
                            padding: const EdgeInsets.all(
                                8.0), // Padding around the icon
                            decoration: BoxDecoration(
                              color:
                                  Colors.white, // White background for the icon
                              shape: BoxShape.circle, // Circular background
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(
                                      0.5), // Optional shadow for the circle
                                  spreadRadius: 1,
                                  blurRadius: 4,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.person,
                              color:
                                  Color(0xFF40189D), // Blue color for the icon
                              size: 20, // Adjust size as needed
                            ),
                          ),
                          onSelected: (String value) async {
                            // Handle selection here
                            if (value == 'Edit Profile') {
                              Get.offAllNamed(AppRoutes.userProfileDetails);
                            } else if (value == 'Sign In') {
                              Get.offAllNamed(AppRoutes.signIn);
                            } else if (value == 'Sign Up') {
                              Get.offAllNamed(AppRoutes.signUp);
                            } else if (value == 'Logout') {
                              await FirebaseAuth.instance.signOut();
                              if (userStates.provider.value == 'google') {
                                await _googleSignIn.signOut();
                              }
                              Get.find<UserController>().clearUserData();
                              Get.offAllNamed(AppRoutes.signIn);
                            } else if (value == 'Change Password') {
                              Get.offAllNamed(AppRoutes.userChangePassword);
                            }
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<String>>[
                            if (userStates.role.value == "user" &&
                                userStates.isAuthenticated.value &&
                                userStates.provider.value == "email") ...[
                              const PopupMenuItem<String>(
                                value: 'Edit Profile',
                                child: Row(
                                  children: [
                                    Icon(Icons.edit, color: Colors.green),
                                    SizedBox(width: 6),
                                    Text("Edit Profile")
                                  ],
                                ),
                              ),
                              const PopupMenuItem<String>(
                                value: 'Change Password',
                                child: Row(
                                  children: [
                                    Icon(Icons.password,
                                        color: Color.fromARGB(255, 21, 53, 79)),
                                    SizedBox(width: 6),
                                    Text("Change Password")
                                  ],
                                ),
                              ),
                              const PopupMenuItem<String>(
                                value: 'Logout',
                                child: Row(
                                  children: [
                                    Icon(Icons.logout, color: Colors.red),
                                    SizedBox(width: 6),
                                    Text("Logout")
                                  ],
                                ),
                              ),
                            ] else if (userStates.role.value == "user" &&
                                userStates.isAuthenticated.value &&
                                userStates.provider.value == "google") ...[
                              const PopupMenuItem<String>(
                                value: 'Edit Profile',
                                child: Row(
                                  children: [
                                    Icon(Icons.edit, color: Colors.green),
                                    SizedBox(width: 6),
                                    Text("Edit Profile")
                                  ],
                                ),
                              ),
                              const PopupMenuItem<String>(
                                value: 'Logout',
                                child: Row(
                                  children: [
                                    Icon(Icons.logout, color: Colors.red),
                                    SizedBox(width: 6),
                                    Text("Logout")
                                  ],
                                ),
                              ),
                            ] else ...[
                              const PopupMenuItem<String>(
                                value: 'Sign In',
                                child: Row(
                                  children: [
                                    Icon(Icons.login, color: Colors.green),
                                    SizedBox(width: 6),
                                    Text("Sign In")
                                  ],
                                ),
                              ),
                              const PopupMenuItem<String>(
                                value: 'Sign Up',
                                child: Row(
                                  children: [
                                    Icon(Icons.login, color: Colors.orange),
                                    SizedBox(width: 6),
                                    Text("Sign Up")
                                  ],
                                ),
                              ),
                            ]
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Search Bar (moves up on focus)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Transform.translate(
                    offset: isSearchFocused
                        ? const Offset(0, 50)
                        : const Offset(
                            0, -30), // Move search bar up when focused
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey
                                .withOpacity(0.3), // Light grey shadow
                            spreadRadius: 1, // How far the shadow spreads
                            blurRadius: 10, // Smoothness of the shadow
                            offset:
                                const Offset(0, 5), // Position the shadow below
                          ),
                        ],
                      ),
                      child: TextField(
                        autofocus: false,
                        onTap: () {
                          setState(() {
                            isSearchFocused = true;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Search job here...',
                          fillColor: Colors
                              .transparent, // Transparent because the background is set in the Container
                          filled: true,
                          prefixIcon:
                              const Icon(Icons.search, color: Colors.grey),
                          suffixIcon: isSearchFocused
                              ? IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    setState(() {
                                      isSearchFocused =
                                          false; // Reset when cross is pressed
                                    });
                                  },
                                )
                              : null,
                          contentPadding: const EdgeInsets.all(10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide
                                .none, // Remove border since Container handles it
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: isSearchFocused ? 70 : 2),
                // Filter Buttons (appear when search bar is focused)
                if (isSearchFocused) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // Show Salary Range Slider on press
                                setState(() {
                                  // You can add more functionality to show the range here if needed
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5), // Adjust padding for size
                                minimumSize: const Size(
                                    60, 30), // Set minimum size for the button
                                backgroundColor: Colors
                                    .white, // Optional: Button background color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      8), // Optional: Rounded corners
                                ),
                              ),
                              child: const Text('Remote',
                                  style: TextStyle(color: Colors.black)),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // Show Salary Range Slider
                                showSalaryRangeDialog(context);
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5), // Adjust padding for size
                                minimumSize: const Size(
                                    60, 30), // Set minimum size for the button
                                backgroundColor: Colors
                                    .white, // Optional: Button background color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      8), // Optional: Rounded corners
                                ),
                              ),
                              child: const Text('Salary Range',
                                  style: TextStyle(color: Colors.black)),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // Show Date Picker
                                _selectDate(context);
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5), // Adjust padding for size
                                minimumSize: const Size(
                                    60, 30), // Set minimum size for the button
                                backgroundColor: Colors
                                    .white, // Optional: Button background color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      8), // Optional: Rounded corners
                                ),
                              ),
                              child: const Text('Date Posted',
                                  style: TextStyle(color: Colors.black)),
                            ),
                            const Icon(Icons.tune, color: Colors.black),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],

                // Job Cards
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children:
                        jobs.map((job) => buildJobCard(job, context)).toList(),
                  ),
                ),
                if (!isLoadingMore)
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors
                            .white, // This will set the button's background color
                      ),
                      onPressed: loadMoreJobs,
                      child: const Text(
                        "Load More",
                        style: TextStyle(color: Color(0xFF40189D)),
                      ),
                    ),
                  ),
                if (isLoadingMore)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildJobCard(Map<String, String> job, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.offAllNamed(AppRoutes.userJobDetailsPage, arguments: {'job': job});
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 15),
        color: Colors.grey[100],
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              // Image with proper fit and constraints
              Container(
                width: 50, // Set a fixed width for the image
                height: 50, // Set a fixed height for the image
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(8), // Optional: for rounded corners
                  image: DecorationImage(
                    image: NetworkImage(job['logo']!),
                    fit: BoxFit
                        .cover, // Adjust the image to fit the container without distortion
                  ),
                ),
              ),
              const SizedBox(
                  width: 15), // Add some space between image and text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Company Title
                    Text(
                      job['company']!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                      overflow: TextOverflow
                          .ellipsis, // Adds ellipsis if text is too long
                      maxLines: 1, // Limits to a single line
                    ),
                    const SizedBox(height: 5),
                    // Job Title
                    Text(
                      job['title']!,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow
                          .ellipsis, // Adds ellipsis if text is too long
                      maxLines: 1, // Limits to a single line
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        const Icon(Icons.currency_exchange,
                            color: Color(0xFF40189D)),
                        const SizedBox(width: 5),
                        Text(
                          job['salary']!,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.work_outline,
                            color: Color(0xFF40189D)),
                        const SizedBox(width: 5),
                        Text(
                          job['location']!,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int currentPage = 1; // Keeps track of the current page of jobs

  void loadMoreJobs() async {
    setState(() {
      isLoadingMore = true;
    });

    // Simulate network call delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      // Load the next 5 jobs based on the current page
      final nextJobs = job.skip(currentPage * 5).take(5).toList();
      jobs.addAll(nextJobs);
      currentPage++; // Move to the next page
      isLoadingMore = false;
    });
  }

  // Function to show Salary Range dialog with sliders
  void showSalaryRangeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Salary Range'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Minimum Salary Slider
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Min Salary'),
                  Text("\\${minSalary.toInt()}"),
                ],
              ),
              Slider(
                value: minSalary,
                min: 10000,
                max: 100000,
                divisions: 10,
                label: minSalary.toString(),
                onChanged: (double value) {
                  setState(() {
                    minSalary = value;
                  });
                },
              ),
              // Maximum Salary Slider
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Max Salary'),
                  Text("\\${maxSalary.toInt()}"),
                ],
              ),
              Slider(
                value: maxSalary,
                min: 20000,
                max: 200000,
                divisions: 10,
                label: maxSalary.toString(),
                onChanged: (double value) {
                  setState(() {
                    maxSalary = value;
                  });
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // Function to show date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Current date as default
      firstDate: DateTime(2000), // Earliest date
      lastDate: DateTime(2100), // Latest date
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked; // Update the selected date
      });
    }
  }
}
