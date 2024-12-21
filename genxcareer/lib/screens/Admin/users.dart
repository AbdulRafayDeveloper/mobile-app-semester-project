import 'package:flutter/material.dart';
import 'package:genxcareer/components/admin_drawer_menu.dart';

class Users extends StatefulWidget {
  const Users({super.key});

  @override
  _UsersState createState() => _UsersState();
}

class _UsersState extends State<Users> {
  bool isSearchFocused = false; // To track if the search bar is focused
  double minSalary = 30000; // Minimum salary default value
  double maxSalary = 100000; // Maximum salary default value
  DateTime? selectedDate; // Store the selected date
  List<Map<String, String>> Users = []; // This will hold the Users displayed
  bool isLoadingMore = false; // To manage the loading state

// Placeholder for user data
  final List<Map<String, String>> user = [
    {
      'name': 'John Doe',
      'email': 'john.doe@example.com',
      'image':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRe3oPvKsA05otgZYGFZmxk5WHLYTFKWOFaNA&s',
    },
    {
      'name': 'Jane Smith',
      'email': 'jane.smith@example.com',
      'image':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRe3oPvKsA05otgZYGFZmxk5WHLYTFKWOFaNA&s',
    },
    {
      'name': 'Alice Johnson',
      'email': 'alice.johnson@example.com',
      'image':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRe3oPvKsA05otgZYGFZmxk5WHLYTFKWOFaNA&s',
    },
    {
      'name': 'Bob Brown',
      'email': 'bob.brown@example.com',
      'image':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRe3oPvKsA05otgZYGFZmxk5WHLYTFKWOFaNA&s',
    },
    {
      'name': 'Emily Davis',
      'email': 'emily.davis@example.com',
      'image':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRe3oPvKsA05otgZYGFZmxk5WHLYTFKWOFaNA&s',
    },
    {
      'name': 'Chris Evans',
      'email': 'chris.evans@example.com',
      'image':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRe3oPvKsA05otgZYGFZmxk5WHLYTFKWOFaNA&s',
    },
    {
      'name': 'Sophia Martinez',
      'email': 'sophia.martinez@example.com',
      'image':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRe3oPvKsA05otgZYGFZmxk5WHLYTFKWOFaNA&s',
    },
  ];

  @override
  void initState() {
    super.initState();
    // Initially load first 5 Users
    Users.addAll(user.take(5));
  }

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; // Get screen size
    return Scaffold(
      backgroundColor: Colors.grey[100], // Light background color
      drawer: Drawer(
        child: const AdminDrawerMenu(), // Use the reusable drawer menu
      ),
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
                              "Users Details",
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
                        child: Builder(
                          builder: (context) => IconButton(
                            icon: const Icon(Icons.menu, color: Colors.white),
                            onPressed: () {
                              Scaffold.of(context).openDrawer();
                            },
                          ),
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
                          hintText: 'Search user here...',
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
                          children: [],
                        ),
                      ],
                    ),
                  ),
                ],

                // user Cards
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: Users.map((user) => buildUserCard(user, context))
                        .toList(),
                  ),
                ),
                if (!isLoadingMore)
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors
                            .white, // This will set the button's background color
                      ),
                      onPressed: loadMoreUsers,
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

  Widget buildUserCard(Map<String, String> user, BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 15),
        color: Colors.grey[100],
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image with proper fit and constraints
              Container(
                width: 50, // Set a fixed width for the image
                height: 50, // Set a fixed height for the image
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(8), // Optional: for rounded corners
                  image: DecorationImage(
                    image: NetworkImage(user['image']!),
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
                    // Name text
                    Text(
                      user['name']!,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow
                          .ellipsis, // Adds ellipsis if text is too long
                      maxLines: 1, // Limits to a single line
                    ),
                    const SizedBox(height: 5),
                    // Email with responsive layout
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.email_outlined,
                            color: Color(0xFF40189D)),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            user['email']!,
                            style: const TextStyle(fontSize: 16),
                            overflow: TextOverflow
                                .ellipsis, // Adds ellipsis if email is too long
                            maxLines: 1,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.delete, color: Colors.red),
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

  int currentPage = 1; // Keeps track of the current page of Users

  void loadMoreUsers() async {
    setState(() {
      isLoadingMore = true;
    });

    // Simulate network call delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      // Load the next 5 Users based on the current page
      final nextUsers = user.skip(currentPage * 5).take(5).toList();
      Users.addAll(nextUsers);
      currentPage++; // Move to the next page
      isLoadingMore = false;
    });
  }
}
