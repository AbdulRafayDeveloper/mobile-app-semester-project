import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:genxcareer/components/admin_drawer_menu.dart';
import 'package:genxcareer/services/user_service.dart';

class Users extends StatefulWidget {
  const Users({super.key});

  @override
  _UsersState createState() => _UsersState();
}

class _UsersState extends State<Users> {
  bool isSearchFocused = false;
  final TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> filteredUsers = [];
  DocumentSnapshot? lastDocument;
  bool isLoadingMore = false;
  bool hasMore = true;
  bool isSearching = false;
  bool isInitialLoading = true;
  int limit = 10;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  void fetchUsers({bool isLoadMore = false}) async {
    if (isLoadingMore && isLoadMore) return;

    setState(() {
      if (!isLoadMore) isInitialLoading = true;
      isLoadingMore = isLoadMore;
    });

    final response = await UserApis().getPaginatedUsers(limit, lastDocument);
    if (response['status'] == 'success') {
      List<Map<String, dynamic>> newUsers = response['data'];
      setState(() {
        if (isLoadMore) {
          users.addAll(newUsers);
        } else {
          users = newUsers;
        }
        filteredUsers = List.from(users);
        lastDocument = response['lastDocument'];
        hasMore = newUsers.length == limit;
      });
    }

    setState(() {
      isLoadingMore = false;
      isInitialLoading = false;
    });
  }

  void onSearch(String query) {
    setState(() {
      isSearching = query.isNotEmpty;
      filteredUsers = users
          .where((user) => user['name']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
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
              });
            }
          },
          child: isInitialLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: double.infinity,
                        height: isSearchFocused ? 0 : size.height * 0.19,
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
                                    "Users Details",
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
                                  icon: const Icon(Icons.menu,
                                      color: Colors.white),
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
                              controller: searchController,
                              autofocus: false,
                              onTap: () {
                                setState(() {
                                  isSearchFocused = true;
                                });
                              },
                              decoration: InputDecoration(
                                hintText: 'Search By Name...',
                                fillColor: Colors.transparent,
                                filled: true,
                                prefixIcon: const Icon(Icons.search,
                                    color: Colors.grey),
                                suffixIcon: isSearchFocused
                                    ? IconButton(
                                        icon: const Icon(Icons.close),
                                        onPressed: () {
                                          setState(() {
                                            isSearchFocused = false;
                                            searchController.clear();
                                            onSearch('');
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: SizedBox(
                            height: size.height * 0.7,
                            child: ListView.builder(
                              itemCount:
                                  filteredUsers.length + (hasMore ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index < filteredUsers.length) {
                                  final user = filteredUsers[index];
                                  return ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Color(0xFF40189D),
                                      child: Text(
                                        'SR.${index + 1}',
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 11),
                                      ),
                                    ),
                                    title: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Text(
                                        user['name'],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                    subtitle: Text(
                                      user['email'],
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  );
                                } else {
                                  return Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Center(
                                      child: isLoadingMore
                                          ? const CircularProgressIndicator()
                                          : ElevatedButton(
                                              onPressed:
                                                  hasMore && !isLoadingMore
                                                      ? () => fetchUsers(
                                                          isLoadMore: true)
                                                      : null,
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Color(0xFF40189D),
                                              ),
                                              child: const Text(
                                                'Load More',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                    ),
                                  );
                                }
                              },
                            )),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
