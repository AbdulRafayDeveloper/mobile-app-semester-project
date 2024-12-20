import 'package:flutter/material.dart';
import 'package:genxcareer/screens/Admin/admin_update.dart';
import 'package:genxcareer/screens/Admin/change_passord.dart';
import 'package:genxcareer/screens/Admin/dashboard.dart';
import 'package:genxcareer/screens/Admin/jobs_detail.dart';
import 'package:genxcareer/screens/Admin/users.dart';
import 'package:genxcareer/screens/jobs_screen.dart';
import 'package:genxcareer/screens/sign_in_screen.dart';
import 'package:genxcareer/screens/users_details.dart';
import 'package:intl/intl.dart'; // For formatting the selected date
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class Jobs extends StatefulWidget {
  const Jobs({super.key});

  @override
  _JobsState createState() => _JobsState();
}

class _JobsState extends State<Jobs> {
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
    'logo': 'https://res.cloudinary.com/vistaprint/images/c_scale,w_448,h_448,dpr_2/f_auto,q_auto/v1705580343/ideas-and-advice-prod/en-us/adidas/adidas.png?_i=AA',
    'description': 'WLorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.',
    'jobType': 'Full-time'
  },
  {
    'company': 'Nextgen Corp',
    'title': 'Backend Developer',
    'salary': '\$800 - \$1,200',
    'location': 'Jakarta, Indonesia',
    'logo': 'https://marketplace.canva.com/EAF7Nm6GMzo/1/0/1600w/canva-black-white-modern-concept-football-club-logo-3-nFuSBwgIA.jpg',
    'description': 'Join our team to develop scalable backend solutions for our growing platform.',
    'jobType': 'Part-time'
  },
  {
    'company': 'Futura Labs',
    'title': 'Frontend Developer',
    'salary': '\$600 - \$900',
    'location': 'Bali, Indonesia',
    'logo': 'https://www.logolounge.com/wp-content/uploads/2023/12/21954_438371-300x300.jpg',
    'description': 'We are looking for a creative Frontend Developer to design user-friendly websites.',
    'jobType': 'Full-time'
  },
  {
    'company': 'Darkseer Studios',
    'title': 'Senior Software Engineer',
    'salary': '\$500 - \$1,000',
    'location': 'Medan, Indonesia',
    'logo': 'https://res.cloudinary.com/vistaprint/images/c_scale,w_448,h_448,dpr_2/f_auto,q_auto/v1705580343/ideas-and-advice-prod/en-us/adidas/adidas.png?_i=AA',
    'description': 'Lead the development of cutting-edge software solutions in a fast-paced environment.',
    'jobType': 'Contract'
  },
  {
    'company': 'Nextgen Corp',
    'title': 'Backend Developer',
    'salary': '\$800 - \$1,200',
    'location': 'Jakarta, Indonesia',
    'logo': 'https://marketplace.canva.com/EAF7Nm6GMzo/1/0/1600w/canva-black-white-modern-concept-football-club-logo-3-nFuSBwgIA.jpg',
    'description': 'Backend development and API integrations for high-traffic platforms.',
    'jobType': 'Full-time'
  },
  {
    'company': 'Futura Labs',
    'title': 'Frontend Developer',
    'salary': '\$600 - \$900',
    'location': 'Bali, Indonesia',
    'logo': 'https://www.logolounge.com/wp-content/uploads/2023/12/21954_438371-300x300.jpg',
    'description': 'Work closely with designers and other developers to create intuitive UI/UX experiences.',
    'jobType': 'Freelance'
  },
  {
    'company': 'Darkseer Studios',
    'title': 'Senior Software Engineer',
    'salary': '\$500 - \$1,000',
    'location': 'Medan, Indonesia',
    'logo': 'https://res.cloudinary.com/vistaprint/images/c_scale,w_448,h_448,dpr_2/f_auto,q_auto/v1705580343/ideas-and-advice-prod/en-us/adidas/adidas.png?_i=AA',
    'description': 'Help shape the future of the company by managing and guiding the tech team.',
    'jobType': 'Full-time'
  },
  {
    'company': 'Nextgen Corp',
    'title': 'Backend Developer',
    'salary': '\$800 - \$1,200',
    'location': 'Jakarta, Indonesia',
    'logo': 'https://marketplace.canva.com/EAF7Nm6GMzo/1/0/1600w/canva-black-white-modern-concept-football-club-logo-3-nFuSBwgIA.jpg',
    'description': 'Join us as we build scalable backend systems for our high-demand applications.',
    'jobType': 'Contract'
  },
  {
    'company': 'Futura Labs',
    'title': 'Frontend Developer',
    'salary': '\$600 - \$900',
    'location': 'Bali, Indonesia',
    'logo': 'https://www.logolounge.com/wp-content/uploads/2023/12/21954_438371-300x300.jpg',
    'description': 'Innovative Frontend Developer wanted to bring designs to life with modern JavaScript frameworks.',
    'jobType': 'Part-time'
  },
  {
    'company': 'Darkseer Studios',
    'title': 'Senior Software Engineer',
    'salary': '\$500 - \$1,000',
    'location': 'Medan, Indonesia',
    'logo': 'https://res.cloudinary.com/vistaprint/images/c_scale,w_448,h_448,dpr_2/f_auto,q_auto/v1705580343/ideas-and-advice-prod/en-us/adidas/adidas.png?_i=AA',
    'description': 'Take ownership of the software architecture and lead a diverse engineering team.',
    'jobType': 'Full-time'
  },
  {
    'company': 'Nextgen Corp',
    'title': 'Backend Developer',
    'salary': '\$800 - \$1,200',
    'location': 'Jakarta, Indonesia',
    'logo': 'https://marketplace.canva.com/EAF7Nm6GMzo/1/0/1600w/canva-black-white-modern-concept-football-club-logo-3-nFuSBwgIA.jpg',
    'description': 'Develop backend services and APIs with a focus on performance and scalability.',
    'jobType': 'Freelance'
  },
  {
    'company': 'Futura Labs',
    'title': 'Frontend Developer',
    'salary': '\$600 - \$900',
    'location': 'Bali, Indonesia',
    'logo': 'https://www.logolounge.com/wp-content/uploads/2023/12/21954_438371-300x300.jpg',
    'description': 'Collaborate with the design team to create pixel-perfect, responsive web pages.',
    'jobType': 'Part-time'
  },
];

  @override
  void initState() {
  super.initState();
  // Initially load first 5 jobs
  jobs.addAll(job.take(5));
}
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; // Get screen size
    return Scaffold(
      backgroundColor: Colors.grey[100], // Light background color
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                
              ),
              child: Center( // Centers the image in the DrawerHeader
                child: SizedBox(
                  width: 500, // Adjust as needed
                  height: 500, // Adjust as needed
                  child: Image(
                    image: AssetImage('assets/new_logo2.png'),
                    fit: BoxFit.contain, // Ensures the image scales proportionally
                  ),
                ),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Dashboard()));
              },
            ),

            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Details'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AdminDetailPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Customers'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Users()));
              },
            ),
             ListTile(
              leading: const Icon(Icons.password),
              title: const Text('Change Password'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AdminPasswordPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> JobsScreen()));
              },
            ),
          ],
        ),
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
                  height: isSearchFocused ? 0 : size.height * 0.19, // Height reduces to 0 when search is focused
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF40189D), Color.fromARGB(255, 111, 57, 238)],
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
                        top: size.height * 0.05, // Adjust this value to center the text vertically
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
                              "Jobs Details",
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
                    offset: isSearchFocused ? const Offset(0, 50) : const Offset(0, -30), // Move search bar up when focused
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3), // Light grey shadow
                            spreadRadius: 1, // How far the shadow spreads
                            blurRadius: 10, // Smoothness of the shadow
                            offset: const Offset(0, 5), // Position the shadow below
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
                          fillColor: Colors.transparent, // Transparent because the background is set in the Container
                          filled: true,
                          prefixIcon: const Icon(Icons.search, color: Colors.grey),
                          suffixIcon: isSearchFocused
                              ? IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    setState(() {
                                      isSearchFocused = false; // Reset when cross is pressed
                                    });
                                  },
                                )
                              : null,
                          contentPadding: const EdgeInsets.all(10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none, // Remove border since Container handles it
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
                    children: jobs.map((job) => buildJobCard(job, context)).toList(),
                  ),
                ),
        if (!isLoadingMore)
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, // This will set the button's background color
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
    onTap: (){
      Navigator.push(context, MaterialPageRoute(builder: (context)=> JobDetailPage(job: job)));
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
                borderRadius: BorderRadius.circular(8), // Optional: for rounded corners
                image: DecorationImage(
                  image: NetworkImage(job['logo']!),
                  fit: BoxFit.cover, // Adjust the image to fit the container without distortion
                ),
              ),
            ),
            const SizedBox(width: 15), // Add some space between image and text
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
                    overflow: TextOverflow.ellipsis, // Adds ellipsis if text is too long
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
                    overflow: TextOverflow.ellipsis, // Adds ellipsis if text is too long
                    maxLines: 1, // Limits to a single line
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      const Icon(Icons.currency_exchange, color: Color(0xFF40189D)),
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
                      const Icon(Icons.work_outline, color: Color(0xFF40189D)),
                      const SizedBox(width: 5),
                      Text(
                        job['location']!,
                        style: const TextStyle(fontSize: 16),
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.delete  , color: Colors.red),
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
}

 