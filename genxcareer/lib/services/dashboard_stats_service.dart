import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardStatsApi {
  final CollectionReference users =
      FirebaseFirestore.instance.collection("users");

  final CollectionReference jobs =
      FirebaseFirestore.instance.collection("jobs");

  // Method to fetch job counts and user count
  Future<Map<String, dynamic>> getJobAndUserCounts() async {
    try {
      // Get all jobs
      QuerySnapshot jobSnapshot = await jobs.get();
      // Get all users
      QuerySnapshot userSnapshot = await users.get();

      // Count the total jobs
      int totalJobs = jobSnapshot.docs.length;

      // Count remote jobs (remote == true)
      int remoteJobs = jobSnapshot.docs
          .where((doc) => doc['remote'] == true)
          .toList()
          .length;

      // Count hybrid jobs (hybrid == true)
      int hybridJobs = jobSnapshot.docs
          .where((doc) => doc['hybrid'] == true)
          .toList()
          .length;

      // Count jobs with both remote and hybrid false (treated as onsite)
      int onsiteJobs = jobSnapshot.docs
          .where((doc) => doc['remote'] == false && doc['hybrid'] == false)
          .toList()
          .length;

      // Count total users
      int totalUsers = userSnapshot.docs.length;

      // Return the counts in a map
      return {
        'totalJobs': totalJobs,
        'totalUsers': totalUsers,
        'remoteJobs': remoteJobs,
        'onsiteJobs': onsiteJobs,
        'hybridJobs': hybridJobs,
      };
    } catch (e) {
      // If there is an error, return the error message
      return {'error': e.toString()};
    }
  }
}
