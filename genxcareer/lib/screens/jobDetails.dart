import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:genxcareer/controller/user_controller.dart';
import 'package:genxcareer/routes/app_routes.dart';
import 'package:genxcareer/services/jobs_service.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class JobDetailsPage extends StatefulWidget {
  final String jobId;

  const JobDetailsPage({Key? key, required this.jobId}) : super(key: key);

  @override
  _AdminJobDetailPageState createState() => _AdminJobDetailPageState();
}

class _AdminJobDetailPageState extends State<JobDetailsPage> {
  late Future<Map<String, dynamic>> _jobDataFuture;
  final userStates = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    _jobDataFuture = fetchJobData(widget.jobId);
  }

  Future<Map<String, dynamic>> fetchJobData(String jobId) async {
    final response = await JobsApis().getOneJob(jobId);

    if (response['status'] == 'success') {
      return response['data'] as Map<String, dynamic>;
    } else {
      throw Exception(response['message']);
    }
  }

  Future<void> _openApplyUrl(String applyUrl) async {
    final Uri url = Uri.parse(applyUrl);

    try {
      await launchUrl(url, mode: LaunchMode.inAppBrowserView);
    } catch (e) {
      Get.snackbar(
        'Application Error',
        'You cannot apply for this job. Please apply for another one.',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 3),
        mainButton: TextButton(
          onPressed: () {
            Get.toNamed(AppRoutes.userJobs);
          },
          child: Text(
            'Back to Jobs',
            style: TextStyle(color: Colors.blue),
          ),
        ),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _showLoginPrompt(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.login, // Login icon
                color: Colors.blue,
                size: 28,
              ),
              SizedBox(width: 10),
              Text(
                "Login Required",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          content: const Text(
            "You need to log in first to apply for a job.",
            style: TextStyle(fontSize: 16),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey, // Button color
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Close",
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Get.toNamed(AppRoutes.signIn);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Button color
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                "Login",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSizeTitle = screenWidth * 0.05; // 6% of screen width
    double fontSizeSubtitle = screenWidth * 0.035; // 4.5% of screen width
    double fontSizeBody = screenWidth * 0.04; // 4% of screen width

    return Scaffold(
      appBar: AppBar(
        title: const Text("Job Details"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.offAllNamed(AppRoutes.userJobs);
          },
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _jobDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          } else if (snapshot.hasData) {
            final jobData = snapshot.data!;

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(26.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  jobData['companyName'] ??
                                      'Company Name Not Mention',
                                  style: TextStyle(
                                    fontSize: fontSizeSubtitle,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  jobData['title'] ?? 'Job Title',
                                  style: TextStyle(
                                    fontSize: fontSizeTitle,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          CircleAvatar(
                            backgroundImage:
                                jobData['companyLogoLink'] != null &&
                                        jobData['companyLogoLink']!.isNotEmpty
                                    ? NetworkImage(jobData['companyLogoLink']!)
                                    : const AssetImage(
                                        'assets/missing_companies_logo.jpeg'),
                            radius: 30,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            side:
                                const BorderSide(color: Colors.grey, width: 1),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 28, vertical: 10),
                          ),
                          child: Text(
                            jobData['employmentStatuses'] != null &&
                                    jobData['employmentStatuses'].isNotEmpty
                                ? '${jobData['employmentStatuses'][0]}'
                                : 'Job Type: N/A',
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Divider(color: Colors.grey.shade300, thickness: 1),
                      const SizedBox(height: 20),
                      buildDetailRow(
                        FontAwesomeIcons.coins,
                        "Salary",
                        jobData['salary'],
                      ),
                      const SizedBox(height: 10),
                      buildDetailRow(
                        Icons.work_outline,
                        "Location",
                        jobData['location'],
                      ),
                      const SizedBox(height: 20),
                      Divider(color: Colors.grey.shade300, thickness: 1),
                      const SizedBox(height: 20),
                      Text(
                        "Job Description",
                        style: TextStyle(
                          fontSize: fontSizeTitle,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        jobData['description'] ?? "No description available.",
                        style: TextStyle(fontSize: fontSizeBody),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            // Check if user is authenticated and has the correct role
                            if (userStates.role.value == "user" &&
                                userStates.isAuthenticated.value) {
                              // If conditions are met, open the apply URL
                              _openApplyUrl(jobData['applyUrl']);
                            } else {
                              // If conditions are not met, show a login prompt
                              _showLoginPrompt(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 28, vertical: 10),
                            backgroundColor: const Color(0xFF40189D),
                          ),
                          child: const Text(
                            'Apply Now',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const Center(
              child: Text("No data available."),
            );
          }
        },
      ),
    );
  }

  Widget buildDetailRow(IconData icon, String label, String? value,
      {int maxLength = 25}) {
    // Ensure the value doesn't exceed maxLength
    String displayValue = (value?.isEmpty ?? true) ? "N/A" : value!;
    if (displayValue.length > maxLength) {
      displayValue = '${displayValue.substring(0, maxLength)}...';
    }

    return Padding(
      padding: const EdgeInsets.only(left: 30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Aligns to top
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color.fromARGB(196, 121, 66, 248),
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              backgroundColor: const Color.fromARGB(142, 147, 104, 248),
              radius: 20,
              child: FaIcon(
                icon,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            // This ensures the text can expand and wrap
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label),
                Text(
                  displayValue,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis, // Adds ellipsis for overflow
                  maxLines: 1, // Ensures the text stays in a single line
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
