import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:genxcareer/components/admin_drawer_menu.dart';
import 'package:genxcareer/routes/app_routes.dart';
import 'package:genxcareer/services/jobs_service.dart';
import 'package:get/get.dart';

class Jobs extends StatefulWidget {
  const Jobs({super.key});

  @override
  _JobsState createState() => _JobsState();
}

class _JobsState extends State<Jobs> {
  bool isSearchFocused = false;
  List<Map<String, String>> jobs = [];
  bool isLoadingMore = false;
  String searchQuery = '';
  DocumentSnapshot? lastDocument;

  @override
  void initState() {
    super.initState();
    loadJobs();
  }

  Future<void> loadJobs() async {
    if (isLoadingMore) return;

    setState(() {
      isLoadingMore = true;
    });

    final result = await JobsApis().getPaginatedJobs(
      8,
      lastDocument,
      searchQuery: searchQuery,
    );

    if (result['status'] == 'success') {
      setState(() {
        jobs.addAll(List<Map<String, String>>.from(result['data'].map((job) {
          return {
            'id': job['id']?.toString() ?? '',
            'companyName': job['companyName']?.toString() ?? '',
            'title': job['title']?.toString() ?? '',
            'salary': job['salary']?.toString() ?? '',
            'location': job['location']?.toString() ?? '',
            'logo': job['companyLogoLink']?.toString() ?? '',
            'description': job['description']?.toString() ?? '',
            'jobType': job['jobType']?.toString() ?? '',
          };
        })));
        lastDocument = result['lastDocument'];
      });
    } else {
      print('Error loading jobs: ${result['message']}');
    }

    setState(() {
      isLoadingMore = false;
    });
  }

  void loadMoreJobs() async {
    await loadJobs();
  }

  void onSearch(String query) {
    setState(() {
      searchQuery = query;
      jobs.clear();
      lastDocument = null;
    });
    loadJobs();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; // Get screen size
    return Scaffold(
      backgroundColor: Colors.grey[100], // Light background color
      drawer: Drawer(
        child: AdminDrawerMenu(), // Use the reusable drawer menu
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
                      bottomLeft: Radius.circular(60),
                      bottomRight: Radius.circular(60),
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Centered Text
                      Positioned(
                        top: size.height * 0.05,
                        left: 30,
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
                    offset: isSearchFocused
                        ? const Offset(0, 50)
                        : const Offset(0, -30),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: TextField(
                        onChanged: onSearch,
                        autofocus: false,
                        onTap: () {
                          setState(() {
                            isSearchFocused = true;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Search job here...',
                          fillColor: Colors.transparent,
                          filled: true,
                          prefixIcon:
                              const Icon(Icons.search, color: Colors.grey),
                          suffixIcon: isSearchFocused
                              ? IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    setState(() {
                                      isSearchFocused = false;
                                    });
                                  },
                                )
                              : null,
                          contentPadding: const EdgeInsets.all(10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: isSearchFocused ? 70 : 2),
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

                // Job Cards
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children:
                        jobs.map((job) => buildJobCard(job, context)).toList(),
                  ),
                ),
                if (jobs.isNotEmpty && lastDocument != null && !isLoadingMore)
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.white, // Button's background color
                      ),
                      onPressed: loadMoreJobs,
                      child: const Text(
                        "Load More",
                        style: TextStyle(color: Color(0xFF40189D)),
                      ),
                    ),
                  ),
                if (jobs.isEmpty && lastDocument == null)
                  Center(
                    child: const Text(
                      "No more jobs available",
                      style: TextStyle(fontSize: 16, color: Colors.black54),
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
        Get.offAllNamed(AppRoutes.adminJobsDetail,
            arguments: {'jobId': job['id']});
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 15),
        color: Colors.grey[100],
        child: Padding(
          padding: const EdgeInsets.all(8),
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
                    image: NetworkImage(
                      job['logo'] ??
                          'data:image/jpeg;base64,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', // Fallback URL for static logo
                    ),
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
                      job['companyName'] ?? 'Unknown Company',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                      overflow: TextOverflow
                          .ellipsis, // Adds ellipsis if text is too long
                      maxLines: 1, // Limits to a single line
                    ),
                    const SizedBox(height: 5),
                    // Job Title with character limit
                    Text(
                      job['title']!.length > 25
                          ? '${job['title']!.substring(0, 25)}...' // Show first 25 characters with ellipsis
                          : job['title']!, // Show full title if it's short
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow
                          .ellipsis, // Adds ellipsis if text is too long
                      maxLines: 1, // Limits to a single line
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(Icons.work_outline,
                            color: Color(0xFF40189D)),
                        const SizedBox(width: 5),
                        // Location with character limit
                        Expanded(
                          child: Text(
                            job['location']!.length > 30
                                ? '${job['location']!.substring(0, 30)}...' // Show first 30 characters with ellipsis
                                : job[
                                    'location']!, // Show full location if it's short
                            style: const TextStyle(fontSize: 14),
                            overflow: TextOverflow
                                .ellipsis, // Adds ellipsis if text is too long
                            maxLines: 1, // Limits to a single line
                          ),
                        ),
                        const Spacer(),
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
}
