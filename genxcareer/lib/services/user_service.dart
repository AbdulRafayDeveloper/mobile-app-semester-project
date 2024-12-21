import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:genxcareer/models/user_model.dart';

class UserApis {
  final CollectionReference users =
      FirebaseFirestore.instance.collection("users");

  // Method to add a user
  Future<Map<String, dynamic>> addUser(UserModel user) async {
    try {
      // Validate user data before attempting to save
      if (user.uid.isEmpty || user.name.isEmpty || user.email.isEmpty) {
        return {
          'status': 'error',
          'message': 'Missing required fields: uid, name, or email.',
          'data': null
        };
      }

      await users.doc(user.uid).set(user.toMap());

      return {
        'status': 'success',
        'message': 'User added successfully!',
        'data': user.toMap(),
      };
    } catch (e) {
      return {
        'status': 'error',
        'message': 'Error adding user: ${e.toString()}',
        'data': null
      };
    }
  }

  // Method to update user profile URL
  Future<Map<String, dynamic>> updateUserProfileUrl(
      String uid, String profileUrl) async {
    try {
      // Validate data before attempting to update
      if (uid.isEmpty || profileUrl.isEmpty) {
        return {
          'status': 'error',
          'message': 'Missing required fields: uid or profileUrl.',
          'data': null
        };
      }

      // Check if user exists before updating
      DocumentSnapshot userDoc = await users.doc(uid).get();
      if (!userDoc.exists) {
        return {'status': 'error', 'message': 'User not found.', 'data': null};
      }

      // Update the user's profile URL
      await users.doc(uid).update({
        'profileUrl': profileUrl,
      });

      return {
        'status': 'success',
        'message': 'Profile URL updated successfully.',
        'data': {
          'uid': uid,
          'profileUrl': profileUrl,
        }
      };
    } catch (e) {
      return {
        'status': 'error',
        'message': 'Error updating profile URL: ${e.toString()}',
        'data': null
      };
    }
  }
}
