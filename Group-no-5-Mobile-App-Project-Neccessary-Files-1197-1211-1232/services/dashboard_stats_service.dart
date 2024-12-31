import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardStatsApi {
  final CollectionReference users =
      FirebaseFirestore.instance.collection("users");

  final CollectionReference jobs =
      FirebaseFirestore.instance.collection("jobs");

  
  Future<Map<String, dynamic>> getJobAndUserCounts() async {
    try {
      
      QuerySnapshot jobSnapshot = await jobs.get();
      
      QuerySnapshot userSnapshot = await users.get();

      int totalJobs = jobSnapshot.docs.length;

      int remoteJobs = jobSnapshot.docs
          .where((doc) => doc['remote'] == true)
          .toList()
          .length;

      int hybridJobs = jobSnapshot.docs
          .where((doc) => doc['hybrid'] == true)
          .toList()
          .length;

      int onsiteJobs = jobSnapshot.docs
          .where((doc) => doc['remote'] == false && doc['hybrid'] == false)
          .toList()
          .length;

      int totalUsers = userSnapshot.docs.length;

      return {
        'totalJobs': totalJobs,
        'totalUsers': totalUsers,
        'remoteJobs': remoteJobs,
        'onsiteJobs': onsiteJobs,
        'hybridJobs': hybridJobs,
      };
    } catch (e) {
      
      return {'error': e.toString()};
    }
  }
}
