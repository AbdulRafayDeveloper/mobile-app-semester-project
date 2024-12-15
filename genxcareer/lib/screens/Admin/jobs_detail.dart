import 'package:flutter/material.dart';
import 'package:genxcareer/screens/Admin/jobs.dart';
import 'package:url_launcher/url_launcher.dart';

class JobDetailPage extends StatelessWidget {
  final JobCard job;

  // Constructor to receive the job object
  JobDetailPage({required this.job});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          job.jobTitle,
          style: TextStyle(color: Colors.white), // Set the title color to white
        ),
         // Make AppBar transparent
        elevation: 0, // Remove the shadow under the AppBar
        iconTheme: IconThemeData(color: Colors.white), // Set the back button color to white
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/HD-wallpaper-back-to-it-background-purple-solid-thumbnail.jpg'),
              fit: BoxFit.cover,
            ),
          ),
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
            color: Colors.black.withOpacity(0.5),
          ),
          // Content body with a scrollable ListView
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Column(
              children: [
                // Job Details Section
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white.withOpacity(0.1), // Slight opacity for background
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
                        '${job.jobTitle}',
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distributes items across the row
                        children: [
                          // Job Title and Company Name with Avatar
                          Row(
                            children: [
                              // Avatar
                              CircleAvatar(
                                radius: 30, // Adjust the radius as needed
                                backgroundImage: NetworkImage(job.imageUrl), // Use NetworkImage to load the image
                              ),
                              const SizedBox(width: 12), // Space between the Avatar and Company Name
                              Text(
                                job.companyName, // Display the company name
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          // Apply Button on the other end
                          ElevatedButton(
                            onPressed: () async {
                              final url = job.applyLink.trim(); // Remove any leading/trailing spaces
                              print('Job Apply Link: $url'); // Debug: Print the apply link

                              // Check if the URL starts with 'http://' or 'https://'
                              if (url.startsWith('http://') || url.startsWith('https://')) {
                                try {
                                  final uri = Uri.parse(url); // Convert the string URL to Uri
                                  print('Parsed URL: $uri'); // Debug: Print the parsed URL

                                  if (await canLaunchUrl(uri)) { // Check if the URL can be launched
                                    await launchUrl(uri); // Launch the URL
                                  } else {
                                    throw 'Could not launch $uri'; // Error if URL can't be opened
                                  }
                                } catch (e) {
                                  print('Error: $e'); // Catch and print any parsing errors
                                }
                              } else {
                                print('Invalid URL format: $url'); // If URL is missing 'http://' or 'https://'
                              }
                            },
                            child: Text('Apply'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Salary: ${job.salaryRange}',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const SizedBox(height: 20),
                      Text(
                        "Description",
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        job.description,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ],
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
