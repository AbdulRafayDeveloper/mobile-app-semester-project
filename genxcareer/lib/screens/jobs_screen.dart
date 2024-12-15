import 'package:flutter/material.dart';
import 'package:genxcareer/screens/Admin/admin_update.dart';
import 'package:genxcareer/screens/Admin/users.dart';
import 'package:genxcareer/screens/sign_in_screen.dart';
import 'package:genxcareer/screens/users_details.dart';

class JobsScreen extends StatefulWidget {
  @override
  _JobsScreenState createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  final List<Map<String, String>> jobs = [
    {
      'company': 'DevsRank',
      'title': 'MERN Developer',
      'location': 'Faisalabad',
      'salary': 'PKR50K - PKR100K',
      'type': 'Full-time',
      'posted': '20d',
      'details': 'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC...'
    },
     {
      'company': 'DevsRank',
      'title': 'MERN Developer',
      'location': 'Faisalabad',
      'salary': 'PKR50K - PKR100K',
      'type': 'Full-time',
      'posted': '20d',
      'details': 'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC...'
    },
     {
      'company': 'DevsRank',
      'title': 'MERN Developer',
      'location': 'Faisalabad',
      'salary': 'PKR50K - PKR100K',
      'type': 'Full-time',
      'posted': '20d',
      'details': 'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC...'
    },
     {
      'company': 'DevsRank',
      'title': 'MERN Developer',
      'location': 'Faisalabad',
      'salary': 'PKR50K - PKR100K',
      'type': 'Full-time',
      'posted': '20d',
      'details': 'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC...'
    },
     {
      'company': 'DevsRank',
      'title': 'MERN Developer',
      'location': 'Faisalabad',
      'salary': 'PKR50K - PKR100K',
      'type': 'Full-time',
      'posted': '20d',
      'details': 'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC...'
    },

     {
      'company': 'DevsRank',
      'title': 'MERN Developer',
      'location': 'Faisalabad',
      'salary': 'PKR50K - PKR100K',
      'type': 'Full-time',
      'posted': '20d',
      'details': 'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC...'
    },
     {
      'company': 'DevsRank',
      'title': 'MERN Developer',
      'location': 'Faisalabad',
      'salary': 'PKR50K - PKR100K',
      'type': 'Full-time',
      'posted': '20d',
      'details': 'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC...'
    },
     {
      'company': 'DevsRank',
      'title': 'MERN Developer',
      'location': 'Faisalabad',
      'salary': 'PKR50K - PKR100K',
      'type': 'Full-time',
      'posted': '20d',
      'details': 'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC...'
    },
     {
      'company': 'DevsRank',
      'title': 'MERN Developer',
      'location': 'Faisalabad',
      'salary': 'PKR50K - PKR100K',
      'type': 'Full-time',
      'posted': '20d',
      'details': 'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC...'
    },
     {
      'company': 'DevsRank',
      'title': 'MERN Developer',
      'location': 'Faisalabad',
      'salary': 'PKR50K - PKR100K',
      'type': 'Full-time',
      'posted': '20d',
      'details': 'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC...'
    },
    // Add more job data...
  ];

  bool isSearching = false;
  TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> filteredJobs = [];

  @override
  void initState() {
    super.initState();
    filteredJobs = jobs;  // Initially show all jobs
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            // Background image
            Positioned.fill(
              child: Image.asset(
                'assets/HD-wallpaper-back-to-it-background-purple-solid-thumbnail.jpg',
                fit: BoxFit.cover,
              ),
            ),
            // AppBar inside the Stack
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AppBar(
                iconTheme: IconThemeData(color: Colors.white),
                leading: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context); // Go back to the previous screen
                    },
                  ),
                ),
                title: isSearching
                    ? Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: TextField(
                            controller: _searchController,
                            autofocus: true,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Search by title...',
                              hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.clear, color: Colors.white),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    filteredJobs = jobs;
                                  });
                                },
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                            onChanged: (query) {
                              setState(() {
                                filteredJobs = jobs
                                    .where((job) =>
                                        job['title']!.toLowerCase().contains(query.toLowerCase()))
                                    .toList();
                              });
                            },
                          ),
                        ),
                      )
                    : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:[ 
                        const Text(
                          'GenX Career',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.normal, fontSize: 26),
                        ),
                           Row(
                              children: [
                                
                                   Text(
                                    "Jobs Based on your Search",
                                    style: TextStyle(
                                        fontSize: 16, fontWeight: FontWeight.normal, color: Colors.white),
                                  ),
                                
                              ],
                            ),
                            
                          
                        ]
                    ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: IconButton(
                      icon: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          isSearching = !isSearching;
                        });
                        if (!isSearching) {
                          _searchController.clear();
                          setState(() {
                            filteredJobs = jobs;
                          });
                        }
                      },
                    ),
                  ),
                  Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: PopupMenuButton<String>(
                    offset: Offset(0, 50), // Adjust position of the dropdown
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: Colors.white,
                    icon: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    onSelected: (value) {
                      if (value == 'Login') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignInScreen()),
                        );
                      } else if (value == 'Edit Details') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => UserDetailPage()),
                        );
                      }
                    },
                    itemBuilder: (BuildContext context) => [
                      PopupMenuItem(
                        value: 'Login',
                        child: Row(
                          children: [
                            Icon(Icons.login, color: Colors.black),
                            SizedBox(width: 10),
                            Text(
                              'Login',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'Edit Details',
                        child: Row(
                          children: [
                            Icon(Icons.edit, color: Colors.black),
                            SizedBox(width: 10),
                            Text(
                              'Edit Details',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuDivider(),
                      PopupMenuItem(
                        value: 'Logout',
                        child: Row(
                          children: [
                            Icon(Icons.logout, color: Colors.red),
                            SizedBox(width: 10),
                            Text(
                              'Logout',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                     
                    ],
                    
                  ),
                ),
                ],
                backgroundColor: Colors.transparent,
                elevation: 0,
                // Increase the height of the AppBar
                toolbarHeight: 100,  // Set the height of the AppBar

              ),
              
            ),
            Positioned(
            top: 100,  // Adjusted to place after the AppBar
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      print('Remote Only filter pressed');
                    },
                    child: Text('Remote Only'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      print('Salary Range filter pressed');
                    },
                    child: Text('Salary Range'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      print('Date Posted filter pressed');
                    },
                    child: Text('Date Posted'),
                  ),
                ],
              ),
            ),
          ),
            // Main content inside Column
            Positioned(
              top: 150,  // Adjusted to accommodate the increased AppBar height
              left: 0,
              right: 0,
              bottom: 0,
              child: Column(
                children: [
                  
                  // Job Cards
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(133, 199, 168, 238),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      
                      margin: const EdgeInsets.all(12),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: filteredJobs.length,
                        itemBuilder: (context, index) {
                          final job = filteredJobs[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                            shape: RoundedRectangleBorder(
                              // White border for the card
                            borderRadius: BorderRadius.circular(8),
                          ),
                            child: InkWell(
                              onTap: () {
                                Future.delayed(const Duration(milliseconds: 200), () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          JobDetailsScreen(job: job),
                                    ),
                                  );
                                });
                              },
                              borderRadius: BorderRadius.circular(8),
                              highlightColor: Colors.grey[500],
                              splashColor: Colors.grey[300],
                              child: Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: ListTile(
                                  
                                  title: Text(
                                    job['company']!,
                                    style: TextStyle(fontSize: 11),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        job['title']!,
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                      ),
                                      Text(job['location']!),
                                      if (job.containsKey('salary')) Text(job['salary']!),
                                      Text(job['type']!),
                                    ],
                                  ),
                                  trailing: SizedBox(
                                    width: 77,
                                    child: Center(
                                      child: Stack(
                                        children: [
                                          
                                          Positioned(
                                            bottom: 0,
                                            left: 0,
                                            right: 0,
                                            child: SizedBox(
                                              height: 30,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Color.fromARGB(255, 67, 1, 129),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(20),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  print("1");
                                                },
                                                child: Text(
                                                  "Apply",
                                                  style: TextStyle(color: Colors.white, fontSize: 11),
                                                ),
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
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class JobDetailsScreen extends StatelessWidget {
  final Map<String, String> job;

  const JobDetailsScreen({required this.job});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            // Background image
            Positioned.fill(
              child: Image.asset(
                'assets/HD-wallpaper-back-to-it-background-purple-solid-thumbnail.jpg',
                fit: BoxFit.cover,
              ),
            ),
            // AppBar on top with transparent background and increased height
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AppBar(
                toolbarHeight: 120, // Increased AppBar height
                backgroundColor: Colors.transparent, // Make app bar transparent
                elevation: 0, // Remove shadow
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white), // Back button in white
                  onPressed: () {
                    Navigator.pop(context); // Go back to the previous screen
                  },
                ),
                title: Text(
                  'Job Details',
                  style: TextStyle(
                    color: Colors.white, // Title color in white
                    fontSize: 26, // Increased font size for the title
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
            // Container with light purple top rounded background, now placed behind the content
            Positioned(
              top: 120, // Start after AppBar
              left: 16, // Added left padding
              right: 16, // Added right padding
              bottom: 0, // Stretch to the bottom
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(133, 199, 168, 238), // Light purple background color
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: SizedBox.expand(),
              ),
            ),
            // Main content inside Positioned widget
            Positioned(
              top: 120, // Start the content after the AppBar
              left: 0,
              right: 0,
              bottom: 0, // Make sure it stretches to the bottom
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Job title and company details
                          Text(
                            job['company']!,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.2, // Add letter spacing
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            job['title']!,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.2, // Add letter spacing
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            job['location']!,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              letterSpacing: 1.0, // Add letter spacing
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            job['salary']!,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              letterSpacing: 1.0, // Add letter spacing
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            job['type']!,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              letterSpacing: 1.0, // Add letter spacing
                            ),
                          ),
                          SizedBox(height: 16),
                          // Job details text
                          Text(
                            job['details']!,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              height: 1.6, // Adjust line height for better readability
                            ),
                          ),
                          SizedBox(height: 32),
                          // Apply button
                          Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12), // Adjust padding for button
                                backgroundColor: const Color.fromARGB(255, 75, 2, 138), // Change button color
                              ),
                              onPressed: () {
                                print("Applied");
                              },
                              child: Text(
                                "Apply Now",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold, // Add font weight for emphasis
                                ),
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
          ],
        ),
      ),
    );
  }
}
