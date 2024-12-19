import 'package:flutter/material.dart';
import 'package:genxcareer/screens/sign_in_screen.dart';
import 'package:genxcareer/screens/users_details.dart';
import 'package:intl/intl.dart'; // For formatting the selected date
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class JobsScreen extends StatefulWidget {
  const JobsScreen({super.key});

  @override
  _JobsScreenState createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
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
                          padding: const EdgeInsets.all(8.0),  // Padding around the icon
                          decoration: BoxDecoration(
                            color: Colors.white,  // White background for the icon
                            shape: BoxShape.circle,  // Circular background
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),  // Optional shadow for the circle
                                spreadRadius: 1,
                                blurRadius: 4,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.person,
                            color: Color(0xFF40189D),  // Blue color for the icon
                            size: 20,  // Adjust size as needed
                          ),
                        ),
                          onSelected: (String value) {
                            // Handle selection here
                            if (value == 'Edit Details') {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> UserDetailPage()));
                            } else if (value == 'Login') {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> SignInScreen()));
                            } else if (value == 'Logout') {
                              //Navigator.push(context, MaterialPageRoute(builder: (context)=> ));
                            }
                          },
                          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                              value: 'Edit Details',
                              child: Row(
                                children: [
                                  Icon(Icons.edit, color: Colors.green),
                                  SizedBox(width: 6),
                                  Text("Edit Details")
                                ],
                              ),
                            ),
                            const PopupMenuItem<String>(
                              value: 'Login',
                              child: Row(
                                children: [
                                  Icon(Icons.login, color: Colors.black),
                                  SizedBox(width: 6),
                                  Text("Login")
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
                            ElevatedButton(
                              onPressed: () {
                                // Show Salary Range Slider on press
                                setState(() {
                                  // You can add more functionality to show the range here if needed
                                });
                              },
                              child: const Text('Remote', style: TextStyle(color: Colors.black)),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // Show Salary Range Slider
                                showSalaryRangeDialog(context);
                              },
                              child: const Text('Salary Range', style: TextStyle(color: Colors.black)),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // Show Date Picker
                                _selectDate(context);
                              },
                              child: const Text('Date Posted', style: TextStyle(color: Colors.black)),
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
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => JobDetailsPage(job: job),
        ),
      );
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



class JobDetailsPage extends StatelessWidget {
  final Map<String, String> job;

  const JobDetailsPage({Key? key, required this.job}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen width for responsive text sizing
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSizeTitle = screenWidth * 0.06; // 6% of screen width
    double fontSizeSubtitle = screenWidth * 0.045; // 4.5% of screen width
    double fontSizeBody = screenWidth * 0.04; // 4% of screen width

    return Scaffold(
      appBar: AppBar(
        title: Text(job['title']!),
        
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(26.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Job details header
                Row(
                  children: [
                    const SizedBox(width: 10),
                    // Left side: Company name and job title
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            job['company']!,
                            style: TextStyle(
                              fontSize: fontSizeSubtitle,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            job['title']!,
                            style: TextStyle(
                              fontSize: fontSizeTitle,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Right side: Logo as CircleAvatar
                    CircleAvatar(
                      backgroundImage: NetworkImage(job['logo']!),
                      radius: 30,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Job type button
                Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text('${job['jobType']!}'),
                    style: ElevatedButton.styleFrom(
                      side: BorderSide(color: Colors.grey, width: 1), // Blue outline
                      padding: EdgeInsets.symmetric(horizontal: 28, vertical: 10), // Adjust padding if needed
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Add a fine grey line after the job type
                Divider(color: Colors.grey.shade300, thickness: 1),
                const SizedBox(height: 20),
                // Salary and Location
               Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Salary Row with icon and text side by side
                Padding(
                  padding: EdgeInsets.only(left: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8), // Padding for outer circle
                        decoration: BoxDecoration(
                          color: Color.fromARGB(196, 121, 66, 248), // Light purple outer circle
                          shape: BoxShape.circle, // Circular shape
                           // Purple border
                        ),
                        child: CircleAvatar(
                          backgroundColor: Color.fromARGB(142, 147, 104, 248), // Same as outer circle color
                          radius: 20, // Size of the inner circle (location icon)
                          child: FaIcon(
                          FontAwesomeIcons.coins,
                          size: 20, // Size of the icon
                          color: Colors.white, // Icon color
                        ),
                        ),
                      ),
                      const SizedBox(width: 10), 
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Salary"),
                          Text(
                            "${job['salary']!}",
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ],
                      )
                      
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                // Location Row with icon and text side by side
                Padding(
                  padding: EdgeInsets.only(left: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8), // Padding for outer circle
                        decoration: BoxDecoration(
                          color: Color.fromARGB(196, 121, 66, 248), // Light purple outer circle
                          shape: BoxShape.circle, // Circular shape
                          
                        ),
                        child: CircleAvatar(
                          backgroundColor: Color.fromARGB(142, 147, 104, 248), // Same as outer circle color
                          radius: 20, // Size of the inner circle (location icon)
                          child: Icon(
                            Icons.work_outline,
                            size: 20, // Size of the icon
                            color: Colors.white, // Icon color
                          ),
                        ),
                      ),
                      const SizedBox(width: 10), // Space between icon and text
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("location"),
                          Text(
                            "${job['location']!}",
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
                const SizedBox(height: 20),
                // Add a fine grey line after the location
                Divider(color: Colors.grey.shade300, thickness: 1),
                const SizedBox(height: 20),

                // Job Description
                Text(
                  "Job Description",
                  style: TextStyle(
                    fontSize: fontSizeSubtitle,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  job['description'] ?? "No description available.",
                  style: TextStyle(fontSize: fontSizeBody),
                ),
                const SizedBox(height: 20),

                Center(
                  child: ElevatedButton(
                      onPressed: () {},
                      child: Text('Apply', style: TextStyle(color: Colors.white),),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 28, vertical: 10), 
                        backgroundColor:Color(0xFF40189D), // Adjust padding if needed
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
}

 


