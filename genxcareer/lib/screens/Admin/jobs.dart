import 'package:flutter/material.dart';
import 'package:genxcareer/screens/Admin/admin_update.dart';
import 'package:genxcareer/screens/Admin/jobs.dart';
import 'package:genxcareer/screens/Admin/users.dart'; // If you want navigation to Jobs page
import 'package:genxcareer/screens/Admin/jobs_detail.dart';
import 'package:genxcareer/screens/jobs_screen.dart';
class Jobs extends StatefulWidget {
  const Jobs({super.key});

  @override
  State<Jobs> createState() => _JobsState();
}

class _JobsState extends State<Jobs> {
  List<JobCard> filteredJobs = jobCards; // Start with the full list of Jobs
  TextEditingController _searchController = TextEditingController();
  bool isSearching = false; // New variable to track if search is active

  // GlobalKey for controlling the Scaffold
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Assign the GlobalKey to Scaffold
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(image: AssetImage('assets/logo.png'))
              ),
              child: const Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.join_full),
              title: const Text('Jobs'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Jobs())); // Close the drawer
                // No navigation needed since we're already on the Jobs screen
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Customers'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Users()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Update Admin'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AdminDetailPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: Colors.purple),
              title: const Text(
                'Log Out',
                style: TextStyle(color: Colors.purple),
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => JobsScreen()));
              },
            ),
          ],
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image for the entire screen
          Image.asset(
            'assets/HD-wallpaper-back-to-it-background-purple-solid-thumbnail.jpg',
            fit: BoxFit.cover,
          ),
          // Overlay for better contrast
          Container(
            color: Colors.black.withOpacity(0.4),
          ),
          Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent, // Make AppBar transparent
                elevation: 0,
                automaticallyImplyLeading: false, // Disable default drawer icon
                flexibleSpace: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 0), // Padding for AppBar content
                  child: Padding(
                    padding: const EdgeInsets.only(top: 38), // Add top padding
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Drawer icon
                        IconButton(
                          icon: const Icon(Icons.menu, color: Colors.white, size: 28),
                          onPressed: () {
                            _scaffoldKey.currentState?.openDrawer(); 
                          },
                        ),
                        
                        isSearching
                            ? Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                  child: TextField(
                                    controller: _searchController,
                                    style: const TextStyle(color: Colors.white),
                                    autofocus: true,
                                    decoration: InputDecoration(
                                      hintText: 'Search by name...',
                                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                                      suffixIcon: IconButton(
                                        icon: const Icon(Icons.clear, color: Colors.white),
                                        onPressed: () {
                                          _searchController.clear();
                                          setState(() {
                                            filteredJobs = jobCards; // Reset filter when cleared
                                          });
                                        },
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.white), // White underline when not focused
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.white), // White underline when focused
                                      ),
                                    ),
                                    onChanged: (query) {
                                      setState(() {
                                        filteredJobs = jobCards
                                            .where((job) => job.jobTitle.toLowerCase().contains(query.toLowerCase()))
                                            .toList();
                                      });
                                    },
                                  ),
                                ),
                              )
                            : const Expanded(
                                child: Align(
                                  alignment: Alignment.center, // Left justify the text
                                  child: Text(
                                    'Job Listings ',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    textAlign: TextAlign.start, // Center the text within its own line
                                  ),
                                ),
                              ),
                        // Search Icon
                        IconButton(
                          icon: const Icon(
                            Icons.search,
                            color: Colors.white,
                            size: 28,
                          ),
                          onPressed: () {
                            setState(() {
                              isSearching = !isSearching; // Toggle search bar visibility
                            });
                            if (!isSearching) {
                              _searchController.clear();
                              setState(() {
                                filteredJobs = jobCards; // Reset filter when closing the search bar
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Reduced space below the AppBar
              Expanded(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  padding: const EdgeInsets.all(12.0), // Add internal padding
                  child: ListView.builder(
                    itemCount: filteredJobs.length,
                    itemBuilder: (context, index) {
                      return _buildJobCard(filteredJobs[index]);
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildJobCard(JobCard job) {
  return GestureDetector(
    onTap: () {
      // Navigate to JobDetailPage and pass the selected job
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => JobDetailPage(
            job: job, // Pass the selected job to the detail page
          ),
        ),
      );
    },
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color.fromARGB(60, 255, 255, 255),
        border: Border.all(
          color: Colors.white,
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            job.companyName,
            style: const TextStyle(
              fontSize: 14,
              color: Color.fromARGB(255, 227, 224, 224),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            job.jobTitle,
            style: const TextStyle(
              fontSize: 28,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            job.jobType,
            style: const TextStyle(
              fontSize: 14,
              color: Color.fromARGB(255, 227, 224, 224),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                job.salaryRange,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.white),
                onPressed: () {
                  // Handle delete functionality here
                },
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

  void _logout(BuildContext context) {
    // Perform logout logic here, for example:
    // - Clear session or authentication data
    // - Navigate to login screen
    Navigator.pushReplacementNamed(context, '/login'); // Assuming you have a login route
  }
}

class JobCard {
  final String companyName;
  final String jobTitle;
  final String jobType;
  final String salaryRange;
  final String description;
  final String imageUrl;
  final String applyLink;

  JobCard({
    required this.companyName,
    required this.jobTitle,
    required this.jobType,
    required this.salaryRange,
    required this.description,
    required this.imageUrl,
    required this.applyLink,
  });
}

final List<JobCard> jobCards = [
  JobCard(
  companyName: 'TechCorp',
  jobTitle: 'Software Engineer',
  jobType: 'Full-Time',
  salaryRange: '\$80,000 - \$100,000',
  description: '''As a Software Engineer at TechCorp, you will be responsible for developing, maintaining, and optimizing software applications. 
                    You will work closely with cross-functional teams including product managers, designers, and QA engineers 
                    to build scalable and efficient systems. You will also have the opportunity to lead projects and mentor junior developers. 
                    Strong proficiency in programming languages such as Java, Python, and C++ is required, along with experience in cloud-based 
                    technologies and version control systems like Git. TechCorp offers a collaborative and innovative work environment 
                    that encourages continuous learning and growth.''',
  imageUrl: 'data:image/png;base64,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', // Add the image URL
  applyLink: 'https://www.systemsltd.com/', // Apply link for the job
),
JobCard(
  companyName: 'DesignPro',
  jobTitle: 'UI/UX Designer',
  jobType: 'Part-Time',
  salaryRange: '\$40,000 - \$60,000',
  description: '''At DesignPro, you will be at the forefront of creating user interfaces that are both visually stunning and highly functional. 
                    You will collaborate with clients and internal teams to design user-centric products, conducting research and usability 
                    testing to inform your designs. Your role will involve wireframing, prototyping, and creating high-fidelity mockups 
                    using tools like Figma and Sketch. We are looking for someone with a strong design portfolio and experience in 
                    responsive web design, with a deep understanding of user behavior and design patterns. As a part-time role, 
                    flexibility in working hours is a key benefit.''',
  imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT1ieKvyy2c8vx7Enz3RJ1hngqY8g-ZNBy_Gw&s', // Add the image URL
  applyLink: 'https://www.devsinc.com/', // Apply link for the job
),
JobCard(
  companyName: 'HealthCare Inc.',
  jobTitle: 'Project Manager',
  jobType: 'Contract',
  salaryRange: '\$70,000 - \$90,000',
  description: '''HealthCare Inc. is looking for an experienced Project Manager to oversee various healthcare projects from start to finish. 
                    You will be responsible for defining project scope, setting timelines, allocating resources, and ensuring that deliverables 
                    are met on time and within budget. Collaboration with cross-functional teams is key, and you will communicate regularly 
                    with stakeholders to ensure that expectations are managed effectively. The ideal candidate will have a strong background 
                    in project management, particularly in the healthcare or medical field, with proven experience using tools like 
                    Microsoft Project and Agile methodologies. This contract position offers flexibility and the opportunity to work on impactful 
                    projects that improve patient care.''',
  imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRo7rRsrHDih337rhum2IpoCJCYBbmcWWJUiQ&s', // Add the image URL
  applyLink: 'https://netsoltech.com/', // Apply link for the job
),

  // Additional JobCard entries...
];
