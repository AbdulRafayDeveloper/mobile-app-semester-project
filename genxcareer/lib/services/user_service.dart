import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:genxcareer/models/user_model.dart';
import 'package:genxcareer/controller/user_controller.dart';
import 'package:get/get.dart';

class UserApis {
  final userController = Get.find<UserController>();
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

  /// Fetch paginated users with optional search query
  Future<Map<String, dynamic>> getPaginatedUsers(
    int limit,
    DocumentSnapshot? lastDocument, {
    String? searchQuery,
  }) async {
    try {
      Query query = users.orderBy('name');

      if (searchQuery != null && searchQuery.isNotEmpty) {
        query = query.where(
          'name',
          isGreaterThanOrEqualTo: searchQuery,
          isLessThanOrEqualTo: searchQuery + '\uf8ff',
        );
      }

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      QuerySnapshot snapshot = await query.limit(limit).get();

      List<Map<String, dynamic>> userList = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        };
      }).toList();

      return {
        'status': 'success',
        'data': userList,
        'lastDocument': snapshot.docs.isNotEmpty ? snapshot.docs.last : null,
      };
    } catch (e) {
      return {
        'status': 'error',
        'message': 'Failed to fetch users: ${e.toString()}',
        'data': null
      };
    }
  }

  // Method to get a user by email
  Future<Map<String, dynamic>> getOneUser(String email) async {
    try {
      // Validate email before attempting to fetch data
      if (email.isEmpty) {
        return {
          'status': 'error',
          'message': 'Email is required.',
          'data': null,
        };
      }

      // Query user by email
      QuerySnapshot query = await users.where('email', isEqualTo: email).get();

      if (query.docs.isEmpty) {
        return {
          'status': 'error',
          'message': 'User not found.',
          'data': null,
        };
      }

      Map<String, dynamic> userData =
          query.docs.first.data() as Map<String, dynamic>;
      String? userName = userData['name'];
      String? userEmail = userData['email'];
      String? profileUrl = userData['profileUrl'];

      if (userName == null ||
          userName.isEmpty ||
          userEmail == null ||
          userEmail.isEmpty) {
        return {
          'status': 'error',
          'message':
              'User Name and Email cannot get properly. Please try again later!',
          'data': null,
        };
      }

      return {
        'status': 'success',
        'message': 'User Record fetched successfully.',
        'data': {
          'name': userName,
          'email': userEmail,
          'profileUrl': profileUrl,
        },
      };
    } catch (e) {
      return {
        'status': 'error',
        'message': 'Error fetching record: ${e.toString()}',
        'data': null,
      };
    }
  }

  // Method to update user profile
  Future<Map<String, dynamic>> updateUserByEmail(
      String email, String profileUrl, String newName) async {
    try {
      // Validate data before attempting to update
      if (email.isEmpty) {
        return {
          'status': 'error',
          'message': 'Missing required fields: email.',
          'data': null
        };
      }

      // Query user by email
      QuerySnapshot query = await users.where('email', isEqualTo: email).get();

      if (query.docs.isEmpty) {
        return {'status': 'error', 'message': 'User not found.', 'data': null};
      }

      // Get the user's document ID
      String userId = query.docs.first.id;

      // Update the user's profile URL
      await users.doc(userId).update({
        'name': newName,
        'profileUrl': profileUrl,
      });

      return {
        'status': 'success',
        'message': 'Profile updated successfully.',
        'data': {
          'name': newName,
          'profileUrl': profileUrl,
        }
      };
    } catch (e) {
      return {
        'status': 'error',
        'message': 'Error updating profile: ${e.toString()}',
        'data': null
      };
    }
  }

// Method to delete a user
  Future<Map<String, dynamic>> deleteUser(String userId) async {
    try {
      // Validate userId
      if (userId.isEmpty) {
        return {
          'status': 'error',
          'message': 'User ID is required.',
          'data': null,
        };
      }

      // Check if the user exists in Firestore
      DocumentSnapshot userDoc = await users.doc(userId).get();
      if (!userDoc.exists) {
        return {
          'status': 'error',
          'message': 'User not found in Firestore.',
          'data': null,
        };
      }

      // Deleting the user from Firestore
      await users.doc(userId).delete();

      return {
        'status': 'success',
        'message': 'User deleted successfully from Database.',
        'data': null,
      };
    } catch (e) {
      return {
        'status': 'error',
        'message': 'Error deleting user: ${e.toString()}',
        'data': null,
      };
    }
  }

  // Method to change the user's password
  Future<Map<String, dynamic>> changePassword(String currentPassword,
      String newPassword, String confirmPassword) async {
    try {
      // Check if newPassword and confirmPassword match
      if (newPassword != confirmPassword) {
        return {
          'status': 'error',
          'message': 'New password and confirm password do not match.',
          'data': null
        };
      }

      // Get the current authenticated user
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return {
          'status': 'error',
          'message': 'User not logged in.',
          'data': null
        };
      }

      // Reauthenticate the user with the current password
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      try {
        await user.reauthenticateWithCredential(credential);
      } catch (e) {
        return {
          'status': 'error',
          'message': 'Current password is incorrect.',
          'data': null
        };
      }

      // If reauthentication is successful, update the password
      await user.updatePassword(newPassword);

      return {
        'status': 'success',
        'message': 'Password updated successfully.',
        'data': null
      };
    } catch (e) {
      return {
        'status': 'error',
        'message': 'Error changing password: ${e.toString()}',
        'data': null
      };
    }
  }
}
