import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
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
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      bool isWide = constraints.maxWidth > 700;
      return Scaffold(
        appBar: AppBar(
          title: const Text('School Monitoring'),
        ),
        body: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: !isWide ? 1.5 : 1,
            crossAxisCount: isWide ? 3 : 1,
            crossAxisSpacing: isWide ? 16.0 : 0,
            mainAxisSpacing: isWide ? 16.0 : 0,
          ),
          itemCount: schools.length,
          itemBuilder: (context, index) {
            return SchoolCard(school: schools[index]);
          },
        ),
      );
    });
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
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      shadowColor: Colors.grey[200],
      elevation: 4.0,
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
                  errorWidget: (context, url, error) => const Icon(Icons.error),
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
    );
  }
}
