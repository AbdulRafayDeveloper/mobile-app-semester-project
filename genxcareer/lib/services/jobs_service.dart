import 'dart:convert';
import 'package:genxcareer/constants/jobsData.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:genxcareer/models/jobs_model.dart';
import 'package:genxcareer/controller/user_controller.dart';
import 'package:get/get.dart';

class JobsApis {
  final userController = Get.find<UserController>();
  final CollectionReference jobs =
      FirebaseFirestore.instance.collection("jobs");

  final String apiUrl = "https://api.theirstack.com/v1/jobs/search";
  final String apiToken =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJhbWlycmFmYXkxMzVAZ21haWwuY29tIiwicGVybWlzc2lvbnMiOiJ1c2VyIn0.xDgZvK_iWtSdhlLHki-_Uj-VNA88WRvi4mZxHBhmvbI";

  // Fetch paginated jobs with optional search query
  Future<Map<String, dynamic>> getPaginatedJobs(
    int limit,
    DocumentSnapshot? lastDocument, {
    String? searchQuery,
  }) async {
    try {
      Query query = jobs.orderBy('title');

      if (searchQuery != null && searchQuery.isNotEmpty) {
        query = query.where(
          'title',
          isGreaterThanOrEqualTo: searchQuery,
          isLessThanOrEqualTo: searchQuery + '\uf8ff',
        );
      }

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      QuerySnapshot snapshot = await query.limit(limit).get();

      List<Map<String, dynamic>> jobsList = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        };
      }).toList();

      return {
        'status': 'success',
        'data': jobsList,
        'lastDocument': snapshot.docs.isNotEmpty ? snapshot.docs.last : null,
      };
    } catch (e) {
      return {
        'status': 'error',
        'message': 'Failed to fetch jobs: ${e.toString()}',
        'data': null
      };
    }
  }

  Future<Map<String, dynamic>> getOneJob(String jobId) async {
    try {
      if (jobId.isEmpty) {
        return {
          'status': 'error',
          'message': 'jobId is required.',
          'data': null,
        };
      }

      DocumentSnapshot jobDoc = await jobs.doc(jobId).get();

      if (!jobDoc.exists) {
        return {
          'status': 'error',
          'message': 'Job not found in Firestore.',
          'data': null,
        };
      }

      // Convert DocumentSnapshot to Map<String, dynamic>
      final jobData = jobDoc.data() as Map<String, dynamic>;

      return {
        'status': 'success',
        'message': 'Job Record fetched successfully.',
        'data': jobData,
      };
    } catch (e) {
      return {
        'status': 'error',
        'message': 'Error fetching record: ${e.toString()}',
        'data': null,
      };
    }
  }

  // Method to delete a job
  Future<Map<String, dynamic>> deleteOneJob(String jobId) async {
    try {
      // Validate jobId
      if (jobId.isEmpty) {
        return {
          'status': 'error',
          'message': 'jobId is required.',
          'data': null,
        };
      }

      // Check if the job exists in Firestore
      DocumentSnapshot jobDoc = await jobs.doc(jobId).get();
      if (!jobDoc.exists) {
        return {
          'status': 'error',
          'message': 'job not found in Firestore.',
          'data': null,
        };
      }

      // Deleting the job from Firestore
      await jobs.doc(jobId).delete();

      return {
        'status': 'success',
        'message': 'job deleted successfully from Database.',
        'data': null,
      };
    } catch (e) {
      return {
        'status': 'error',
        'message': 'Error deleting job: ${e.toString()}',
        'data': null,
      };
    }
  }

  Future<Map<String, dynamic>> fetchAndSaveJobs() async {
    try {
      int page = 1;
      int limit = 1;
      int postedAtMaxAgeDays = 15;
      bool includeTotalResults = false;

      print("Fetching jobs from the API...");

      final body = jsonEncode({
        'page': page,
        'limit': limit,
        'posted_at_max_age_days': postedAtMaxAgeDays,
        'include_total_results': includeTotalResults,
        'job_title_or': jobsTitleForFetching,
      });

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
        body: body,
      );

      if (response.statusCode != 200) {
        print("API call failed with status: ${response.statusCode}");
        return {
          'status': 'error',
          'message': 'Failed to fetch jobs',
          'data': null,
        };
      }

      final data = jsonDecode(response.body);
      final List<dynamic> jobData = data['data'] ?? [];

      print("Jobs fetched from API: $jobData");

      List<JobListingModel> jobsToSave = [];

      final oneMinuteAgo = DateTime.now().subtract(Duration(minutes: 60));

      final oldJobsSnapshot = await jobs
          .where('createdAt',
              isGreaterThan: oneMinuteAgo) // Use DateTime directly
          .get();

      print("Comparison time (oneMinuteAgo): $oneMinuteAgo");
      print("oldJobsSnapshot: $oldJobsSnapshot");
      print("oldJobsSnapshot is empty: ${oldJobsSnapshot.docs.isEmpty}");

      if (oldJobsSnapshot.docs.isNotEmpty) {
        for (var doc in oldJobsSnapshot.docs) {
          DateTime createdAt = (doc['createdAt'] as Timestamp).toDate();
          print("Job ID ${doc.id} - Created At: $createdAt");

          if (createdAt.isBefore(oneMinuteAgo)) {
            print("Deleting job with ID ${doc.id} (older than 25 minutes)");
            await doc.reference.delete(); // Delete old job
            print("Deleted job with ID ${doc.id}");
          }
        }
      } else {
        print("No old jobs found to delete.");
      }

      // Add new jobs to Firestore
      for (var job in jobData) {
        // Clean the description
        final cleanDescription = job['description']
            ?.replaceAll('*', ' ')
            .replaceAll('\\n', ' ')
            .replaceAll(RegExp(r'  +'), ' ')
            .replaceAll('\\', '');

        // Check if job already exists
        final existingJob = await jobs
            .where('thierStackJobId', isEqualTo: job['id'])
            .limit(1)
            .get();

        if (existingJob.docs.isNotEmpty) {
          print("Job with ID ${job['id']} already exists.");
          continue;
        }

        // Create job model
        JobListingModel jobModel = JobListingModel(
          thierStackJobId: job['id'] ?? 0,
          title: job['job_title'] ?? "No title provided",
          applyUrl: job['url'] ?? "",
          companyName: job['company'] ?? "Unknown Company",
          finalUrl: job['final_url'] ?? "",
          sourceUrl: job['source_url'] ?? "",
          location: job['location'] ?? "Location not specified",
          stateCode: job['state_code'] ?? "Unknown",
          remote: job['remote'] ?? false,
          hybrid: job['hybrid'] ?? false,
          country:
              job['country'] ?? job['country_code'] ?? "Country not specified",
          seniority: job['seniority'] ?? "Not specified",
          salary: job['salary_string'] ??
              job['min_annual_salary'] ??
              "Not disclosed",
          minAnnualSalary: job['min_annual_salary'],
          maxAnnualSalary: job['max_annual_salary'],
          salaryCurrency: job['salary_currency'] ?? "USD",
          description: cleanDescription ?? "No description provided",
          industry:
              job['company_object']?['industry'] ?? "Industry not specified",
          employmentStatuses:
              List<String>.from(job['employment_statuses'] ?? []),
          companyLogoLink: job['company_object']?['logo'],
          companyUrl: job['company_object']?['url'],
          numberOfJobs: job['company_object']?['num_jobs'],
          foundedYear: job['company_object']?['founded_year'],
          jobPostDate: job['date_posted'] != null
              ? DateTime.parse(job['date_posted'])
              : DateTime.now(),
          createdAt: DateTime.now(), // Store DateTime directly
        );

        jobsToSave.add(jobModel);
      }

      final batch = FirebaseFirestore.instance.batch();

      for (var job in jobsToSave) {
        final jobRef = jobs.doc(); // This will create new document references
        batch.set(jobRef, job.toMap());
      }

      await batch.commit();

      print("Jobs saved successfully!");

      return {
        'status': 'success',
        'message': '${jobsToSave.length} jobs fetched and saved successfully!',
        'data': jobsToSave,
      };
    } catch (e) {
      print("Error occurred: ${e.toString()}");
      return {
        'status': 'error',
        'message': 'Error fetching and saving jobs: ${e.toString()}',
        'data': null,
      };
    }
  }
}
