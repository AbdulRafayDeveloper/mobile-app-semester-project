import 'package:flutter/material.dart';

class JobsScreen extends StatelessWidget {
  final List<Map<String, String>> jobs = [
    {
      'company': 'DevsRank',
      'title': 'MERN Developer',
      'location': 'Faisalabad',
      'salary': 'PKR50K - PKR100K',
      'type': 'Full-time',
      'posted': '20d',
      'details':
          'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of "de Finibus Bonorum et Malorum" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, "Lorem ipsum dolor sit amet..", comes from a line in section 1.10.32. The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from "de Finibus Bonorum et Malorum" by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham.'
    },
    {
      'company': 'DevsRank',
      'title': 'MERN Developer',
      'location': 'Faisalabad',
      'salary': 'PKR50K - PKR100K',
      'type': 'Full-time',
      'posted': '20d',
      'details': 'Detailed description for MERN Developer at DevsRank.'
    },
    {
      'company': 'DevsRank',
      'title': 'MERN Developer',
      'location': 'Faisalabad',
      'salary': 'PKR50K - PKR100K',
      'type': 'Full-time',
      'posted': '20d',
      'details': 'Detailed description for MERN Developer at DevsRank.'
    },
    {
      'company': 'DevsRank',
      'title': 'MERN Developer',
      'location': 'Faisalabad',
      'salary': 'PKR50K - PKR100K',
      'type': 'Full-time',
      'posted': '20d',
      'details': 'Detailed description for MERN Developer at DevsRank.'
    },
    {
      'company': 'DevsRank',
      'title': 'MERN Developer',
      'location': 'Faisalabad',
      'salary': 'PKR50K - PKR100K',
      'type': 'Full-time',
      'posted': '20d',
      'details': 'Detailed description for MERN Developer at DevsRank.'
    },
    {
      'company': 'DevsRank',
      'title': 'MERN Developer',
      'location': 'Faisalabad',
      'salary': 'PKR50K - PKR100K',
      'type': 'Full-time',
      'posted': '20d',
      'details': 'Detailed description for MERN Developer at DevsRank.'
    },
    {
      'company': 'DevsRank',
      'title': 'MERN Developer',
      'location': 'Faisalabad',
      'salary': 'PKR50K - PKR100K',
      'type': 'Full-time',
      'posted': '20d',
      'details': 'Detailed description for MERN Developer at DevsRank.'
    },
    {
      'company': 'DevsRank',
      'title': 'MERN Developer',
      'location': 'Faisalabad',
      'salary': 'PKR50K - PKR100K',
      'type': 'Full-time',
      'posted': '20d',
      'details': 'Detailed description for MERN Developer at DevsRank.'
    },
    {
      'company': 'Pak Logics',
      'title': 'MERN Stack Developer',
      'location': 'Faisalabad',
      'type': 'Full-time',
      'posted': '2d',
      'details': 'Detailed description for MERN Stack Developer at Pak Logics.'
    },
    {
      'company': 'Devontix Solutions',
      'title': 'MERN Stack Developer',
      'location': 'Faisalabad',
      'salary': 'PKR25K - PKR40K',
      'type': 'Full-time',
      'posted': '2d',
      'details':
          'Detailed description for MERN Stack Developer at Devontix Solutions.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'GenX Career',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.person,
                color: Colors.white,
              ),
              onPressed: () {
                // Sorting logic here
              },
            ),
          ],
          backgroundColor: Color(0xFF9866C7),
        ),
        body: Column(
          children: [
            Container(
              height: 38,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 1),
                  ),
                ],
                borderRadius: BorderRadius.circular(40),
              ),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color.fromARGB(255, 188, 187, 187),
                  ),
                  labelText: "Search Jobs",
                  labelStyle: const TextStyle(
                    color: Color.fromARGB(255, 188, 187, 187),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Text("Jobs Based on your Search",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: jobs.length,
                itemBuilder: (context, index) {
                  final job = jobs[index];
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    child: InkWell(
                      onTap: () {
                        Future.delayed(const Duration(milliseconds: 200), () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => JobDetailsScreen(job: job),
                            ),
                          );
                        });
                      },
                      borderRadius:
                          BorderRadius.circular(8), // Matches the card's border
                      highlightColor: Colors.grey[500], // Light grey highlight
                      splashColor:
                          Colors.grey[300], // Slightly darker grey for ripple
                      child: ListTile(
                        leading: const Icon(Icons.business,
                            color: Color(0xFF9866C7)),
                        title: Text(
                          job['company']!,
                          style: TextStyle(fontSize: 11),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              job['title']!,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(job['location']!),
                            if (job.containsKey('salary')) Text(job['salary']!),
                            Text(job['type']!),
                          ],
                        ),
                        trailing: SizedBox(
                          width: 77,
                          child: Center(
                            child: Stack(
                              children: [
                                Positioned(
                                  bottom: 22,
                                  left: 0,
                                  right: 0,
                                  child: IconButton(
                                    icon: const Icon(Icons.info,
                                        color: Color(0xFF9866C7)),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              JobDetailsScreen(job: job),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: SizedBox(
                                    height: 30,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFF9866C7),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                      onPressed: () {
                                        print("1");
                                      },
                                      child: Text(
                                        "Apply",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 11),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class JobDetailsScreen extends StatelessWidget {
  final Map<String, String> job;

  const JobDetailsScreen({required this.job});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title:
              const Text('Job Details', style: TextStyle(color: Colors.white)),
          backgroundColor: Color(0xFF9866C7),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.business, color: Color(0xFF9866C7)),
                    SizedBox(width: 8),
                    Text(
                      '${job['company']}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Text(job['title']!,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('${job['location']}'),
                if (job.containsKey('salary')) Text('${job['salary']}'),
                const SizedBox(height: 16),
                Text(
                  'Job Highlights:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Text('Type: ${job['type']}'),
                const SizedBox(height: 16),
                Text(
                  'Job Details:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Text(job['details']!,
                    style: const TextStyle(
                        fontSize: 16, color: Color.fromARGB(255, 96, 94, 94))),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF9866C7),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            print("1");
                          },
                          child: Text(
                            "Easy Apply",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          )),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
