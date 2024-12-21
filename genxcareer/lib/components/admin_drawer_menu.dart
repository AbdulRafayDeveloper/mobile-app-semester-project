import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:genxcareer/controller/user_controller.dart';
import 'package:get/get.dart';
import 'package:genxcareer/routes/app_routes.dart';

class AdminDrawerMenu extends StatelessWidget {
  const AdminDrawerMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        const DrawerHeader(
          decoration: BoxDecoration(),
          child: Center(
            child: SizedBox(
              width: 150,
              height: 150,
              child: Image(
                image: AssetImage('assets/new_logo2.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.join_full),
          title: const Text('Dashboard'),
          onTap: () {
            Get.offAllNamed(AppRoutes.adminDashboard);
          },
        ),
        ListTile(
          leading: const Icon(Icons.edit),
          title: const Text('Edit Profile'),
          onTap: () {
            Get.offAllNamed(AppRoutes.adminEditDetails);
          },
        ),
        ListTile(
          leading: const Icon(Icons.password),
          title: const Text('Change Password'),
          onTap: () {
            Get.offAllNamed(AppRoutes.adminChangePassword);
          },
        ),
        ListTile(
          leading: const Icon(Icons.work),
          title: const Text('Jobs List'),
          onTap: () {
            Get.offAllNamed(AppRoutes.adminJobs);
          },
        ),
        ListTile(
          leading: const Icon(Icons.people),
          title: const Text('Users List'),
          onTap: () {
            Get.offAllNamed(AppRoutes.adminCustomersList);
          },
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Logout'),
          onTap: () async {
            await FirebaseAuth.instance.signOut();
            Get.find<UserController>().clearUserData();
            Get.offAllNamed(AppRoutes.signIn);
          },
        ),
      ],
    );
  }
}
