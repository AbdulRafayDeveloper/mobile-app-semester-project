import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:genxcareer/routes/app_routes.dart';
import 'package:genxcareer/services/jobs_service.dart';
import 'package:get/get.dart';

class AdminJobDetailPage extends StatefulWidget {
  final String jobId;

  const AdminJobDetailPage({Key? key, required this.jobId}) : super(key: key);

  @override
  _AdminJobDetailPageState createState() => _AdminJobDetailPageState();
}

class _AdminJobDetailPageState extends State<AdminJobDetailPage> {
  late Future<Map<String, dynamic>> _jobDataFuture;

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

  @override
  Widget build(BuildContext context) {
    
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSizeTitle = screenWidth * 0.05;
    double fontSizeSubtitle = screenWidth * 0.035; 
    double fontSizeBody = screenWidth * 0.04; 

    return Scaffold(
      appBar: AppBar(
        title: const Text("Job Details"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.offAllNamed(AppRoutes.adminJobs);
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
                          child: Text(
                            jobData['employmentStatuses'] != null &&
                                    jobData['employmentStatuses'].isNotEmpty
                                ? '${jobData['employmentStatuses'][0]}'
                                : 'Job Type: N/A',
                          ),
                          style: ElevatedButton.styleFrom(
                            side:
                                const BorderSide(color: Colors.grey, width: 1),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 28, vertical: 10),
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
    
    String displayValue = (value?.isEmpty ?? true) ? "N/A" : value!;
    if (displayValue.length > maxLength) {
      displayValue = displayValue.substring(0, maxLength) + '...';
    }

    return Padding(
      padding: const EdgeInsets.only(left: 30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, 
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
                  overflow: TextOverflow.ellipsis, 
                  maxLines: 1, 
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
