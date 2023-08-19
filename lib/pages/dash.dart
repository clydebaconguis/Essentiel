import 'dart:convert';

import 'package:essentiel/models/billing_assessment.dart';
import 'package:essentiel/models/enrollment_info.dart';
import 'package:essentiel/pages/class_schedule.dart';
import 'package:essentiel/pages/school_calendar.dart';
import 'package:essentiel/provider/navigation_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:essentiel/api/my_api.dart';

class Dash extends StatefulWidget {
  final Function(Widget, String) updateData;
  const Dash({super.key, required this.updateData});

  @override
  State<Dash> createState() => _DashState();
}

class _DashState extends State<Dash> {
  String id = '0';
  List<EnrollmentInfo> enInfoData = [];
  List<BillingAssessmentInfo> billInfoData = [];
  List<String> years = [];
  List<String> months = [];
  String selectedYear = '';
  String selectedMonth = '';
  String activenav = '';
  double totalAss = 0.0;
  bool isCollege = false;

  // Example list of years

  EnrollmentInfo? getSelectedEnrollmentInfo() {
    if (selectedYear.isEmpty) return null;
    // Retrieve the enrollment info based on the selected year
    return enInfoData.firstWhere(
      (enrollment) => enrollment.sydesc.contains(selectedYear),
      orElse: () => EnrollmentInfo(
          sydesc: '',
          levelname: '',
          sectionname: '',
          semid: 0,
          dateenrolled: '',
          syid: 0,
          levelid: 0,
          sectionid: 0,
          isactive: 0,
          strandid: 0,
          semester: '',
          strandcode: '',
          courseabrv: ''),
    );
  }

  EnrollmentInfo? getCollegeEnr() {
    return enInfoData[enInfoData.length - 1];
  }

  void totalAssessment() {
    for (var bill in billInfoData) {
      var intValue = double.parse(bill.balance);
      totalAss += intValue;
    }
  }

  BillingAssessmentInfo? getSelectedAssessmentInfo() {
    if (selectedMonth.isEmpty) {
      return null;
    }
    // Retrieve the assessment info based on the selected year
    else {
      return billInfoData.firstWhere(
        (assessment) => assessment.particulars
            .toLowerCase()
            .contains(selectedMonth.toLowerCase()),
        orElse: () => BillingAssessmentInfo(
            particulars: '', amount: '', duedate: '', balance: ''),
      );
    }
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  getEnrollment() async {
    await CallApi().getEnrollmentInfo(id).then((response) {
      if (mounted) {
        setState(() {
          Iterable list = json.decode(response.body);
          // print(list);
          enInfoData = list.map((model) {
            return EnrollmentInfo.fromJson(model);
          }).toList();
          for (var element in enInfoData) {
            if (element.isactive == 1) {
              years.add(element.sydesc);
              selectedYear = element.sydesc;
              if (element.courseabrv.isNotEmpty) {
                isCollege = true;
              }
            }
          }

          Set<String> uniqueSet = years.toSet();
          years = uniqueSet.toList();
        });
      }
    });
  }

  getBilling() async {
    await CallApi().getBillingInfo(id).then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        // print(list);
        billInfoData = list.map((model) {
          return BillingAssessmentInfo.fromJson(model);
        }).toList();

        for (var element in billInfoData) {
          months.add(element.particulars);
        }
        selectedMonth = billInfoData[0].particulars;
        totalAssessment();
      });
    });
  }

  getUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final json = preferences.getString('studid');

    if (json != null) {
      setState(() {
        id = json;
      });
      getBilling();
      getEnrollment();
    }
  }

  @override
  Widget build(BuildContext context) {
    EnrollmentInfo? selectedEnrollment =
        isCollege ? getCollegeEnr() : getSelectedEnrollmentInfo();
    BillingAssessmentInfo? selectedAssessment = getSelectedAssessmentInfo();
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      // var isWide = constraints.maxWidth > 800;
      return ListView(
        padding: const EdgeInsets.only(left: 5, right: 5),
        children: [
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    final provider =
                        Provider.of<NavigationProvider>(context, listen: false);

                    provider.setActiveNav('Class Schedule');
                    // Add your desired action when the card is tapped here
                    widget.updateData(const ClassSchedPage(), "Class Schedule");
                  },
                  child: Card(
                    elevation: 0,
                    child: Container(
                      padding: const EdgeInsets.all(0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.4),
                            offset: const Offset(0.0, 0.0),
                            blurRadius: kIsWeb ? 15.0 : 10.0,
                            spreadRadius: 4.0,
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 10),
                          const Icon(
                            Icons.calendar_month_outlined,
                            size: 90,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 11, horizontal: 0),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(5),
                                bottomLeft: Radius.circular(5),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Student Schedule',
                                    style: GoogleFonts.prompt(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    final provider =
                        Provider.of<NavigationProvider>(context, listen: false);

                    provider.setActiveNav('School Calendar');
                    // Add your desired action when the card is tapped here
                    widget.updateData(
                        const SchoolCalendar(), "School Calendar");
                  },
                  child: Card(
                    elevation: 0,
                    child: Container(
                      padding: const EdgeInsets.all(0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.4),
                            offset: const Offset(0.0, 0.0),
                            blurRadius: 10.0,
                            spreadRadius: 4.0,
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Icon(
                            Icons.fact_check_outlined,
                            size: 90,
                            color: Colors.indigo[800],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 11, horizontal: 0),
                            decoration: BoxDecoration(
                              color: Colors.indigo[
                                  800], // Replace with your desired background color
                              borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(5),
                                bottomLeft: Radius.circular(5),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'School Activities',
                                    style: GoogleFonts.prompt(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Card(
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.4),
                      offset: const Offset(0.0, 0.0),
                      blurRadius: 15.0,
                      spreadRadius: 4.0,
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2.0, horizontal: 10.0),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(5.0),
                          topRight: Radius.circular(5.0),
                        ),
                        color: Colors.blue[
                            400], // Replace with your desired tinted color
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.filter_alt_outlined,
                              color: Colors.white),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              'Enrollment Info',
                              style: GoogleFonts.prompt(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          selectedYear.isNotEmpty
                              ? DropdownButton<String>(
                                  value: selectedYear,
                                  hint: const Text('Select Year'),
                                  onChanged: (String? newValue) {
                                    // setState(() {
                                    //   selectedYear = newValue!;
                                    // });
                                  },
                                  items: years.map<DropdownMenuItem<String>>(
                                    (String year) {
                                      return DropdownMenuItem<String>(
                                        enabled: false,
                                        value: year,
                                        child: Text(
                                          year,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold,
                                            color: Colors
                                                .white, // Replace with your desired text color
                                          ),
                                        ),
                                      );
                                    },
                                  ).toList(),
                                  style: const TextStyle(
                                    color: Colors
                                        .black, // Replace with your desired text color
                                  ),
                                  underline:
                                      Container(), // To hide the underline
                                  dropdownColor: Colors.blue[
                                      300], // Replace with your desired dropdown background color
                                )
                              : const CircularProgressIndicator(),
                        ],
                      ),
                    ),
                    if (selectedEnrollment != null)
                      Column(
                        children: [
                          if (selectedEnrollment.courseabrv.isNotEmpty)
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[
                                    100], // Replace with your desired tinted color
                                borderRadius: BorderRadius.circular(0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 13.0, horizontal: 12.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Course',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                        color: Colors
                                            .black87, // Replace with your desired text color
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    selectedEnrollment.courseabrv,
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                      color: Colors
                                          .black87, // Replace with your desired text color
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors
                                  .white, // Replace with your desired tinted color
                              borderRadius: BorderRadius.circular(0),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 13.0, horizontal: 12.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Section',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                      color: Colors
                                          .black87, // Replace with your desired text color
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  selectedEnrollment.sectionname,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                    color: Colors
                                        .black87, // Replace with your desired text color
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[
                                  100], // Replace with your desired tinted color
                              borderRadius: BorderRadius.circular(0),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 13.0, horizontal: 12.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '${selectedEnrollment.courseabrv.isEmpty ? "Grade Level" : "Year Level"} ',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                      color: Colors
                                          .black87, // Replace with your desired text color
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  selectedEnrollment.levelname,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                    color: Colors
                                        .black87, // Replace with your desired text color
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              color: Colors
                                  .white, // Replace with your desired tinted color
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(5.0),
                                  bottomRight: Radius.circular(5.0)),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 13.0, horizontal: 12.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Date Enrolled',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                      color: Colors
                                          .black87, // Replace with your desired text color
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                const Spacer(),
                                Expanded(
                                  child: Text(
                                    selectedEnrollment.dateenrolled,
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                      color: Colors
                                          .black87, // Replace with your desired text color
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.4),
                      offset: const Offset(0.0, 0.0),
                      blurRadius: 15.0,
                      spreadRadius: 4.0,
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2.0, horizontal: 10.0),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(5.0),
                          topRight: Radius.circular(5.0),
                        ),
                        color: Colors.yellow[
                            800], // Replace with your desired tinted color
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.filter_alt_outlined,
                              color: Colors.white),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              'Billing Assessment',
                              style: GoogleFonts.prompt(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          selectedMonth.isNotEmpty
                              ? DropdownButton<String>(
                                  alignment: Alignment.topRight,
                                  value: selectedMonth,
                                  hint: const Text('Select Month'),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedMonth = newValue!;
                                    });
                                  },
                                  items: months.map<DropdownMenuItem<String>>(
                                    (String month) {
                                      return DropdownMenuItem<String>(
                                        value: month,
                                        child: Text(
                                          month,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          maxLines: 1,
                                        ),
                                      );
                                    },
                                  ).toList(),
                                  underline:
                                      Container(), // To hide the underline
                                  dropdownColor: Colors.yellow[
                                      800], // Replace with your desired dropdown background color
                                )
                              : const CircularProgressIndicator(),
                        ],
                      ),
                    ),
                    if (selectedAssessment != null)
                      Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors
                                  .white, // Replace with your desired tinted color
                              borderRadius: BorderRadius.circular(0),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 13, horizontal: 12),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Particulars',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors
                                          .black87, // Replace with your desired text color
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                const Spacer(),
                                Expanded(
                                  child: Text(
                                    'Amount',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors
                                          .black87, // Replace with your desired text color
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[
                                  100], // Replace with your desired tinted color
                              borderRadius: BorderRadius.circular(0),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 13, horizontal: 12.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    selectedAssessment.particulars,
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                      color: Colors
                                          .black87, // Replace with your desired text color
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    '₱ ${selectedAssessment.amount}', // Add the peso sign before the amount
                                    style: GoogleFonts.prompt(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                      color: Colors
                                          .black87, // Replace with your desired text color
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              color: Colors
                                  .white, // Replace with your desired tinted color
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(5.0),
                                bottomRight: Radius.circular(5.0),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 13.0, horizontal: 12.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Total Assessment',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                      color: Colors
                                          .black87, // Replace with your desired text color
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    '\u20B1 $totalAss', // Add the peso sign before the amount
                                    style: GoogleFonts.prompt(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                      color: Colors
                                          .black87, // Replace with your desired text color
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
