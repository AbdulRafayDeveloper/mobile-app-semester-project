import 'dart:convert';

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
    } else {
      print('Error loading jobs: ${result['message']}');
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

  Future<void> showDeleteConfirmationDialog(String jobId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this job?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () async {
                await handleDeleteJob(jobId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> handleDeleteJob(String jobId) async {
    try {
      Map<String, dynamic> response = await JobsApis().deleteOneJob(jobId);

      if (response['status'] == 'success') {
        setState(() {
          allJobs.removeWhere((job) => job['id'] == jobId);
          jobs.removeWhere((job) => job['id'] == jobId);
        });

        Get.snackbar(
          'Success',
          response['message'],
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Error',
          response['message'],
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
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
                  height: isSearchFocused
                      ? 0
                      : size.height *
                          0.16, 
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
                      
                      Positioned(
                        top: size.height * 0.04,
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

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  
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
                

                SizedBox(height: 10 ),
                

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
                            Colors.white,
                      ),
                      onPressed: loadMoreJobs,
                      child: const Text(
                        "Load More",
                        style: TextStyle(color: Color(0xFF40189D)),
                      ),
                    ),
                  ),
                if (jobs.isEmpty && lastDocument == null && isLoadingMore == false)
                  Center(
                    child: const Text(
                      "No more jobs available",
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  ),
                if (isLoadingMore)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        SizedBox(height:150),
                        CircularProgressIndicator(),
                        SizedBox(height: 20),
                        Text(
                          "Loading data...",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
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
              
              Container(
                width: 50,
                height: 50, 
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(8), 
                  image: DecorationImage(
                    image: job['logo'] != null && job['logo']!.isNotEmpty
                        ? NetworkImage(job['logo']!)
                        : const AssetImage(
                            'assets/missing_companies_logo.jpeg'),
                    fit: BoxFit
                        .cover, 
                  ),
                ),
              ),
              const SizedBox(
                  width: 15), 
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
                      overflow: TextOverflow
                          .ellipsis, 
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
                      overflow: TextOverflow
                          .ellipsis, 
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
                                : job[
                                    'location']!, 
                            style: const TextStyle(fontSize: 14),
                            overflow: TextOverflow
                                .ellipsis, 
                            maxLines: 1, 
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            showDeleteConfirmationDialog(job['id']!);
                          },
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
