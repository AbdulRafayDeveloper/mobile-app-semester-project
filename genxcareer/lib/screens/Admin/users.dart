import 'package:flutter/material.dart';
import 'package:genxcareer/screens/Admin/admin_update.dart';
import 'package:genxcareer/screens/Admin/jobs.dart';
import 'package:genxcareer/screens/jobs_screen.dart';
import 'package:genxcareer/screens/sign_in_screen.dart';

class Users extends StatefulWidget {
  const Users({super.key});

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  List<UserCard> filteredUsers = userCards;
  TextEditingController _searchController = TextEditingController();
  bool isSearching = false;

  // GlobalKey for controlling the Scaffold
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Assign the GlobalKey to Scaffold
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
           const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(image: AssetImage('assets/logo.png'))
              ),
              child: const Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.join_full),
              title: const Text('Jobs'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Jobs()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Customers'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Users()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Update Admin'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AdminDetailPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: Colors.purple),
              title: const Text(
                'Log Out',
                style: TextStyle(color: Colors.purple),
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => JobsScreen()));
              },
            ),
          ],
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/HD-wallpaper-back-to-it-background-purple-solid-thumbnail.jpg',
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withOpacity(0.4),
          ),
          Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                automaticallyImplyLeading: false, // Disable default drawer icon
                flexibleSpace: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 38),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Drawer icon
                        IconButton(
                          icon: const Icon(Icons.menu, color: Colors.white, size: 28),
                          onPressed: () {
                            _scaffoldKey.currentState?.openDrawer(); // Open the drawer
                          },
                        ),
                        // Title or search field
                        isSearching
                            ? Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                  child: TextField(
                                    controller: _searchController,
                                    autofocus: true,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      hintText: 'Search by name...',
                                      hintStyle:
                                          TextStyle(color: Colors.white.withOpacity(0.6)),
                                      suffixIcon: IconButton(
                                        icon: const Icon(Icons.clear, color: Colors.white),
                                        onPressed: () {
                                          _searchController.clear();
                                          setState(() {
                                            filteredUsers = userCards;
                                          });
                                        },
                                      ),
                                      enabledBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.white),
                                      ),
                                      focusedBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.white),
                                      ),
                                    ),
                                    onChanged: (query) {
                                      setState(() {
                                        filteredUsers = userCards
                                            .where((user) => user.name
                                                .toLowerCase()
                                                .contains(query.toLowerCase()))
                                            .toList();
                                      });
                                    },
                                  ),
                                ),
                              )
                            : const Expanded(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Your Customers',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ),
                        // Search icon
                        IconButton(
                          icon: const Icon(
                            Icons.search,
                            color: Colors.white,
                            size: 28,
                          ),
                          onPressed: () {
                            setState(() {
                              isSearching = !isSearching;
                            });
                            if (!isSearching) {
                              _searchController.clear();
                              setState(() {
                                filteredUsers = userCards;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  padding: const EdgeInsets.all(12.0),
                  child: ListView.builder(
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      return _buildUserCard(filteredUsers[index]);
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(UserCard user) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color.fromARGB(60, 255, 255, 255),
        border: Border.all(
          color: Colors.white,
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(user.avatar),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  user.email,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            onPressed: () {
              // Handle delete functionality here
            },
          ),
        ],
      ),
    );
  }
}

class UserCard {
  final String name;
  final String email;
  final String avatar;

  UserCard({
    required this.name,
    required this.email,
    required this.avatar,
  });
}

final List<UserCard> userCards = [
  UserCard(
    name: 'Maria Green',
    email: 'maria@gmail.com',
    avatar:
        "https://plus.unsplash.com/premium_photo-1678197937465-bdbc4ed95815?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cGVyc29ufGVufDB8fDB8fHww",
  ),
  UserCard(
    name: 'John Smith',
    email: 'john@gmail.com',
    avatar:
        'https://images.pexels.com/photos/1681010/pexels-photo-1681010.jpeg?cs=srgb&dl=pexels-creationhill-1681010.jpg&fm=jpg',
  ),
  UserCard(
    name: 'Eva Robinson',
    email: 'eva@gmail.com',
    avatar:
        'https://plus.unsplash.com/premium_photo-1678197937465-bdbc4ed95815?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cGVyc29ufGVufDB8fDB8fHww',
  ),
];
