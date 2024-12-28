import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AdminJobDetailPage extends StatelessWidget {
  final Map<String, String> jobId;

  const AdminJobDetailPage({Key? key, required this.jobId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen width for responsive text sizing
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSizeTitle = screenWidth * 0.06; // 6% of screen width
    double fontSizeSubtitle = screenWidth * 0.045; // 4.5% of screen width
    double fontSizeBody = screenWidth * 0.04; // 4% of screen width

    return Scaffold(
      appBar: AppBar(
        title: Text(jobId['title']!),
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
                            jobId['company']!,
                            style: TextStyle(
                              fontSize: fontSizeSubtitle,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            jobId['title']!,
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
                      backgroundImage: NetworkImage(jobId['logo']!),
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
                    child: Text('${jobId['jobType']!}'),
                    style: ElevatedButton.styleFrom(
                      side: BorderSide(
                          color: Colors.grey, width: 1), // Blue outline
                      padding: EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 10), // Adjust padding if needed
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
                            padding: const EdgeInsets.all(
                                8), // Padding for outer circle
                            decoration: BoxDecoration(
                              color: Color.fromARGB(196, 121, 66,
                                  248), // Light purple outer circle
                              shape: BoxShape.circle, // Circular shape
                              // Purple border
                            ),
                            child: CircleAvatar(
                              backgroundColor: Color.fromARGB(142, 147, 104,
                                  248), // Same as outer circle color
                              radius:
                                  20, // Size of the inner circle (location icon)
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
                                "${jobId['salary']!}",
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
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
                            padding: const EdgeInsets.all(
                                8), // Padding for outer circle
                            decoration: BoxDecoration(
                              color: Color.fromARGB(196, 121, 66,
                                  248), // Light purple outer circle
                              shape: BoxShape.circle, // Circular shape
                            ),
                            child: CircleAvatar(
                              backgroundColor: Color.fromARGB(142, 147, 104,
                                  248), // Same as outer circle color
                              radius:
                                  20, // Size of the inner circle (location icon)
                              child: Icon(
                                Icons.work_outline,
                                size: 20, // Size of the icon
                                color: Colors.white, // Icon color
                              ),
                            ),
                          ),
                          const SizedBox(
                              width: 10), // Space between icon and text
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("location"),
                              Text(
                                "${jobId['location']!}",
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
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
                  jobId['description'] ?? "No description available.",
                  style: TextStyle(fontSize: fontSizeBody),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
