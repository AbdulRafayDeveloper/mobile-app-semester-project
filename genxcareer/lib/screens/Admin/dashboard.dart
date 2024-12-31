import 'package:flutter/material.dart';
import 'package:genxcareer/components/admin_drawer_menu.dart';
import 'package:genxcareer/services/dashboard_stats_service.dart';
import 'package:pie_chart/pie_chart.dart'; 

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
   
    dashboardStats = DashboardStatsApi().getJobAndUserCounts();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; 
    final double width = size.width; 
    final double height = size.height;

    return Scaffold(
      backgroundColor: Colors.grey[100], 
      drawer: Drawer(
        child: AdminDrawerMenu(), 
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

              Map<String, double> dataMap = {
                "Remote": data['remoteJobs'].toDouble(),
                "Onsite": data['onsiteJobs'].toDouble(),
                "Hybrid": data['hybridJobs'].toDouble(),
              };
              List<Color> colorList = [
                Color(0xFF40189D), 
                Colors.green, 
                Colors.blue,
              ];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
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
                                      width * 0.08, 
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Dashboard",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      width * 0.05,
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
                    padding: EdgeInsets.all(width * 0.05),
                    child: Column(
                      children: [
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            
                            Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Container(
                                width: width * 0.4,
                                padding: EdgeInsets.all(
                                    width * 0.05), 
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
                            
                            Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Container(
                                width: width * 0.4,
                                padding: EdgeInsets.all(
                                    width * 0.05),
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
                        
                        PieChart(
                          dataMap: dataMap,
                          chartType: ChartType.ring,
                          colorList: colorList,
                          chartRadius:
                              width / 2.5, 
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
