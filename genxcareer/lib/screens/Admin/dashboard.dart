import 'package:flutter/material.dart';
import 'package:genxcareer/components/admin_drawer_menu.dart';
import 'package:genxcareer/services/dashboard_stats_service.dart';
import 'package:pie_chart/pie_chart.dart'; // Import pie_chart package

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late Future<Map<String, dynamic>> dashboardStats;

  @override
  void initState() {
    super.initState();
    // Fetch the dashboard statistics when the screen loads
    dashboardStats = DashboardStatsApi().getJobAndUserCounts();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; // Get screen size
    final double width = size.width; // For easy reference
    final double height = size.height;

    return Scaffold(
      backgroundColor: Colors.grey[100], // Light background color
      drawer: Drawer(
        child: AdminDrawerMenu(), // Use the reusable drawer menu
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder<Map<String, dynamic>>(
            future: dashboardStats,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      SizedBox(height:350),
                      CircularProgressIndicator(),
                      SizedBox(height: 20),
                      Text(
                        "Loading data...",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                );
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (!snapshot.hasData || snapshot.data == null) {
                return Center(child: Text('No data available'));
              }

              var data = snapshot.data!;

              // Pie chart data from API response
              Map<String, double> dataMap = {
                "Remote": data['remoteJobs'].toDouble(),
                "Onsite": data['onsiteJobs'].toDouble(),
                "Hybrid": data['hybridJobs'].toDouble(),
              };

              // Color configuration for the pie chart
              List<Color> colorList = [
                Color(0xFF40189D), // Purple for Remote
                Colors.green, // Green for Onsite
                Colors.blue, // Blue for Hybrid
              ];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Purple Header
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: double.infinity,
                    height: 150,
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
                          top: height * 0.05,
                          left: 30,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "GenX Career",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      width * 0.08, // Responsive font size
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Dashboard",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      width * 0.05, // Responsive font size
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
                  const SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.all(width * 0.05), // Dynamic padding
                    child: Column(
                      children: [
                        // Your Cards
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Total Jobs Card
                            Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Container(
                                width: width * 0.4, // Responsive width
                                padding: EdgeInsets.all(
                                    width * 0.05), // Dynamic padding
                                child: Column(
                                  children: [
                                    Icon(Icons.work,
                                        size: 50, color: Color(0xFF40189D)),
                                    SizedBox(height: 10),
                                    Text(
                                      "Total Jobs",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      "${data['totalJobs']}",
                                      style: TextStyle(
                                        fontSize: 22,
                                        color: Color(0xFF40189D),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Total Users Card
                            Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Container(
                                width: width * 0.4, // Responsive width
                                padding: EdgeInsets.all(
                                    width * 0.05), // Dynamic padding
                                child: Column(
                                  children: [
                                    Icon(Icons.people,
                                        size: 50, color: Colors.green),
                                    SizedBox(height: 10),
                                    Text(
                                      "Total Users",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      "${data['totalUsers']}",
                                      style: TextStyle(
                                        fontSize: 22,
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 80),
                        // Pie Chart
                        PieChart(
                          dataMap: dataMap,
                          chartType: ChartType.ring,
                          colorList: colorList,
                          chartRadius:
                              width / 2.5, // Adjust size based on screen width
                          centerText: "Job Types",
                          legendOptions: const LegendOptions(
                            showLegends: true,
                            legendPosition: LegendPosition.right,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
