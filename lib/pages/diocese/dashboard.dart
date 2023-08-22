import 'package:cached_network_image/cached_network_image.dart';
import 'package:essentiel/components/copyright.dart';
import 'package:essentiel/pages/diocese/school/school_main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<School> filteredSchools = [];
  final List<School> schools = [
    School(
        name: 'HOLY SPIRIT ACADEMY OF LAOAG',
        imageUrl: 'https://hsa-essentiel.ckgroup.ph/schoollogo/schoollogo.jpg',
        abbv: 'HSA'),
    School(
        name: 'IMMACULATE CONCEPTION ACADEMY',
        imageUrl: 'https://ica-essentiel.ckgroup.ph/schoollogo/schoollogo.jpg',
        abbv: 'ICA'),
    School(
      name: 'SAINT ANNE ACADEMY',
      imageUrl:
          'https://dlces.org/wp-content/uploads/2023/04/saint-anne-academy.png',
      abbv: 'SAA',
    ),
    School(
      name: 'ST. LAWRENCE ACADEMY',
      imageUrl:
          'https://dlces.org/wp-content/uploads/2023/04/st.lawrence-academy-bangui.png',
      abbv: 'SLA',
    ),
  ];

  @override
  void initState() {
    super.initState();
    filteredSchools = schools;
  }

  void filterSchools(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredSchools = schools;
      } else {
        filteredSchools = schools.where((school) {
          return school.name.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        bool isWide = constraints.maxWidth > 700;
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.grey[900],
            title: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Row(
                  children: <Widget>[
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      'School Monitoring',
                      style: GoogleFonts.prompt(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(), // Add spacing between title and logout button
                    IconButton(
                      icon: const Icon(Icons.exit_to_app),
                      onPressed: () {
                        // Implement logout logic here
                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => LoginScreen()),
                        // );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: isWide
                        ? const EdgeInsets.symmetric(
                            horizontal: 5.0,
                            vertical: 30.0,
                          )
                        : const EdgeInsets.only(
                            left: 16.0, right: 16.0, top: 16, bottom: 10),
                    child: TextField(
                      onChanged: filterSchools,
                      decoration: InputDecoration(
                        labelText: 'Search School',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              5.0), // Adjust the radius as needed
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 5.0), // Adjust the value as needed
                      ),
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: constraints.maxWidth < 600 ? 1.5 : 1,
                        crossAxisCount: constraints.maxWidth >= 1000
                            ? 3
                            : constraints.maxWidth > 600
                                ? 2
                                : 1,
                        crossAxisSpacing: 2.0,
                        mainAxisSpacing: 2.0,
                      ),
                      itemCount: filteredSchools.length,
                      itemBuilder: (context, index) {
                        return SchoolCard(school: filteredSchools[index]);
                      },
                    ),
                  ),
                  const Copyright(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class School {
  final String abbv;
  final String name;
  final String imageUrl;

  School({required this.abbv, required this.name, required this.imageUrl});
}

class SchoolCard extends StatelessWidget {
  final School school;

  const SchoolCard({super.key, required this.school});

  @override
  Widget build(BuildContext context) {
    // double screenWidth = MediaQuery.of(context).size.width;
    return Card(
      margin: const EdgeInsets.all(5.0),
      elevation: 0,
      child: GestureDetector(
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SchoolMain()),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                offset: const Offset(0.0, 0.0),
                blurRadius: 8.0,
                spreadRadius: 2.0,
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CachedNetworkImage(
                      height: 120,
                      width: 120,
                      imageUrl: school.imageUrl,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                    // Image.asset(
                    //   school.imageUrl,
                    //   width: 120,
                    // ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      school.abbv,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    Text(
                      school.name,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
