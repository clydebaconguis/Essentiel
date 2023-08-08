import 'package:essentiel/provider/navigation_provider.dart';
import 'package:essentiel/widget/navigation_drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'dash.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => NavigationProvider(),
        child: MaterialApp(
          // color: Colors.black12,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: GoogleFonts.poppinsTextTheme(
              Theme.of(context)
                  .textTheme, // Apply Poppins font to the default text theme
            ),
          ),
          home: const Homepage(
            title: 'Essentiel',
          ),
        ),
      );
}

class Homepage extends StatefulWidget {
  const Homepage({super.key, required String title});

  @override
  State<Homepage> createState() => _HomepageState();
}

class BillingAssessmentInfo {
  final String particulars;
  final String amount;
  final String balance;
  final String duedate;

  BillingAssessmentInfo({
    required this.particulars,
    required this.amount,
    required this.balance,
    required this.duedate,
  });

  factory BillingAssessmentInfo.fromJson(Map json) {
    var particulars = json['particulars'] ?? '';
    var amount = json['amount'] ?? '';
    var balance = json['balance'] ?? '';
    var duedate = json['duedate'] ?? '';
    return BillingAssessmentInfo(
        particulars: particulars,
        amount: amount,
        duedate: duedate,
        balance: balance);
  }
}

class EnrollmentInfo {
  final int syid;
  final int levelid;
  final int sectionid;
  final String sydesc;
  final String levelname;
  final String sectionname;
  final int semid;
  final String dateenrolled;
  final int isactive;
  final int strandid;
  final String semester;
  final String strandcode;

  EnrollmentInfo({
    required this.levelid,
    required this.sectionid,
    required this.syid,
    required this.sydesc,
    required this.levelname,
    required this.sectionname,
    required this.semid,
    required this.dateenrolled,
    required this.isactive,
    required this.strandid,
    required this.semester,
    required this.strandcode,
  });

  factory EnrollmentInfo.fromJson(Map json) {
    var syid = json['syid'] ?? 0;
    var levelid = json['levelid'] ?? 0;
    var sectionid = json['sectionid'] ?? 0;
    var sydesc = json['sydesc'] ?? '';
    var levelname = json['levelname'] ?? '';
    var sectionname = json['sectionname'] ?? '';
    var semid = json['semid'] ?? 0;
    var dateenrolled = json['dateenrolled'] ?? '';
    var isactive = json['isactive'] ?? 0;
    var strandid = json['strandid'] ?? 0;
    var semester = json['semester'] ?? '';
    var strandcode = json['strandcode'] ?? '';
    return EnrollmentInfo(
      syid: syid,
      sydesc: sydesc,
      levelname: levelname,
      sectionname: sectionname,
      semid: semid,
      dateenrolled: dateenrolled,
      levelid: levelid,
      sectionid: sectionid,
      isactive: isactive,
      strandid: strandid,
      semester: semester,
      strandcode: strandcode,
    );
  }
}

class _HomepageState extends State<Homepage> {
  // Widget currentPage = const Dash(updateData: (const ClassSchedPage(),""));
  late Widget currentPage;
  String pageName = 'Dashboard';

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  updateData(Widget page, String pName) {
    setState(() {
      currentPage = page;
      pageName = pName;
    });
  }

  @override
  void initState() {
    currentPage = Dash(
      updateData: updateData,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var spctColor = const Color.fromARGB(255, 7, 5, 102);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        drawer: NavigationDrawerWidget(updateData: updateData),
        key: _scaffoldKey,
        appBar: AppBar(
          shadowColor: Colors.white38,
          toolbarHeight: 65,
          titleSpacing: 0,
          elevation: 4.0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(
              Icons.menu,
              color: Colors.black, // Set the color of the icon
            ),
            onPressed: _openDrawer,
          ),
          title: Padding(
            padding: const EdgeInsets.only(
                right: 14), // Add desired padding on the right side
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 23,
                  backgroundImage: AssetImage("images/spctLogo.jpg"),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    pageName,
                    style: GoogleFonts.prompt(
                      fontSize: 22,
                      color: spctColor,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 20, right: 5, left: 5),
          child: currentPage ==
                  Dash(
                    updateData: updateData,
                  )
              ? Dash(
                  updateData: updateData,
                )
              : currentPage,
        ),
      ),
    );
  }
}
