import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:genxcareer/components/admin_drawer_menu.dart';
import 'package:genxcareer/controller/user_controller.dart';
import 'package:genxcareer/routes/app_routes.dart';
import 'package:genxcareer/services/jobs_service.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class JobsScreen extends StatefulWidget {
  const JobsScreen({super.key});

  @override
  _JobsState createState() => _JobsState();
}

class _JobsState extends State<JobsScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final userStates = Get.find<UserController>();
  bool isSearchFocused = false;
  List<Map<String, String>> allJobs = [];
  List<Map<String, String>> jobs = [];
  bool isLoadingMore = false;
  String searchQuery = '';
  DocumentSnapshot? lastDocument;

  @override
  void initState() {
    super.initState();
    loadJobs();
  }

  Future<void> loadMoreJobs() async {
    if (isLoadingMore || lastDocument == null) return;

    await loadJobs();
  }

  Future<void> loadJobs() async {
    if (isLoadingMore) return;

    setState(() {
      isLoadingMore = true;
    });

    final result = await JobsApis().getPaginatedJobs(8, lastDocument);

    if (result['status'] == 'success' && result['data'].isNotEmpty) {
      setState(() {
        List<Map<String, String>> fetchedJobs =
            List<Map<String, String>>.from(result['data'].map((job) {
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
        }));

        allJobs.addAll(fetchedJobs);
        jobs = List.from(allJobs);
        lastDocument = result['lastDocument'];
      });
    } else if (result['data'].isEmpty) {
      setState(() {
        lastDocument = null;
      });
    }

    setState(() {
      isLoadingMore = false;
    });
  }

  void onSearch(String query) {
    setState(() {
      searchQuery = query;

      if (query.isEmpty) {
        jobs = List.from(allJobs);
      } else {
        jobs = allJobs
            .where((job) =>
                job['title']!.toLowerCase().contains(query.toLowerCase()) ||
                job['companyName']!
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                job['location']!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      drawer: Drawer(
        child: AdminDrawerMenu(),
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            if (isSearchFocused) {
              setState(() {
                isSearchFocused = false;
                FocusScope.of(context).unfocus();
              });
            }
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: isSearchFocused ? 0 : size.height * 0.16,
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
                      bottomLeft: Radius.circular(80),
                      bottomRight: Radius.circular(80),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: size.height * 0.025,
                        left: 30,
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                      Positioned(
                        top: 10,
                        right: 10,
                        child: PopupMenuButton<String>(
                          icon: Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 4,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.person,
                              color: Color(0xFF40189D),
                              size: 20,
                            ),
                          ),
                          onSelected: (String value) async {
                            if (value == 'Edit Profile') {
                              Get.offAllNamed(AppRoutes.userProfileDetails);
                            } else if (value == 'Change Password') {
                              Get.offAllNamed(AppRoutes.userChangePassword);
                            } else if (value == 'Sign In') {
                              Get.offAllNamed(AppRoutes.signIn);
                            } else if (value == 'Sign Up') {
                              Get.offAllNamed(AppRoutes.signUp);
                            } else if (value == 'Logout') {
                              await FirebaseAuth.instance.signOut();
                              if (userStates.provider.value == 'google') {
                                await _googleSignIn.signOut();
                              }
                              Get.find<UserController>().clearUserData();
                              Get.offAllNamed(AppRoutes.signIn);
                            } else if (value == 'Change Password') {
                              Get.offAllNamed(AppRoutes.userChangePassword);
                            }
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<String>>[
                            if (userStates.role.value == "user" &&
                                userStates.isAuthenticated.value &&
                                userStates.provider.value == "email") ...[
                              const PopupMenuItem<String>(
                                value: 'Edit Profile',
                                child: Row(
                                  children: [
                                    Icon(Icons.edit, color: Colors.green),
                                    SizedBox(width: 6),
                                    Text("Edit Profile")
                                  ],
                                ),
                              ),
                              const PopupMenuItem<String>(
                                value: 'Change Password',
                                child: Row(
                                  children: [
                                    Icon(Icons.password,
                                        color: Color.fromARGB(255, 21, 53, 79)),
                                    SizedBox(width: 6),
                                    Text("Change Password")
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
                            ] else if (userStates.role.value == "user" &&
                                userStates.isAuthenticated.value &&
                                userStates.provider.value == "google") ...[
                              const PopupMenuItem<String>(
                                value: 'Edit Profile',
                                child: Row(
                                  children: [
                                    Icon(Icons.edit, color: Colors.green),
                                    SizedBox(width: 6),
                                    Text("Edit Profile")
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
                            ] else ...[
                              const PopupMenuItem<String>(
                                value: 'Sign In',
                                child: Row(
                                  children: [
                                    Icon(Icons.login, color: Colors.green),
                                    SizedBox(width: 6),
                                    Text("Sign In")
                                  ],
                                ),
                              ),
                              const PopupMenuItem<String>(
                                value: 'Sign Up',
                                child: Row(
                                  children: [
                                    Icon(Icons.login, color: Colors.orange),
                                    SizedBox(width: 6),
                                    Text("Sign Up")
                                  ],
                                ),
                              ),
                            ]
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
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
                                    searchQuery = '';
                                    jobs = List.from(allJobs);
                                    FocusScope.of(context).unfocus();
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
                SizedBox(
                  height: 10,
                ),
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
                        backgroundColor: Colors.white,
                      ),
                      onPressed: loadMoreJobs,
                      child: const Text(
                        "Load More",
                        style: TextStyle(color: Color(0xFF40189D)),
                      ),
                    ),
                  ),
                if (jobs.isEmpty &&
                    lastDocument == null &&
                    isLoadingMore == false)
                  const Center(
                    child: Text(
                      "No more jobs available",
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  ),
                if (isLoadingMore)
                  const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        SizedBox(height: 180),
                        CircularProgressIndicator(),
                        SizedBox(height: 20),
                        Text(
                          "Loading data...",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
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
        Get.offAllNamed(AppRoutes.userJobDetailsPage,
            arguments: {'jobId': job['id']});
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        color: Colors.grey[100],
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: job['logo'] != null && job['logo']!.isNotEmpty
                        ? NetworkImage(job['logo']!)
                        : const AssetImage(
                            'assets/missing_companies_logo.jpeg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job['companyName'] ?? 'Unknown Company',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      job['title']!.length > 25
                          ? '${job['title']!.substring(0, 25)}...'
                          : job['title']!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(Icons.work_outline,
                            color: Color(0xFF40189D)),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            job['location']!.length > 30
                                ? '${job['location']!.substring(0, 22)}...'
                                : job['location']!,
                            style: const TextStyle(fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
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
