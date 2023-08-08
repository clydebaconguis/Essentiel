import 'dart:convert';

import 'package:essentiel/pages/billing_information.dart';
import 'package:essentiel/pages/class_schedule.dart';
import 'package:essentiel/pages/school_calendar.dart';
import 'package:essentiel/provider/navigation_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/my_api.dart';
import 'home.dart';

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
  double totalAss = 0.0;
  List<String> years = [];
  String selectedYear = '';
  String selectedMonth = '';
  List<String> months = [];

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
          strandcode: ''),
    );
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
      setState(() {
        Iterable list = json.decode(response.body);
        print(list);
        enInfoData = list.map((model) {
          return EnrollmentInfo.fromJson(model);
        }).toList();

        for (var element in enInfoData) {
          if (element.isactive == 1) {
            years.add(element.sydesc);
            selectedYear = element.sydesc;
          }
        }

        Set<String> uniqueSet = years.toSet();
        years = uniqueSet.toList();
      });
    });
  }

  getBilling() async {
    await CallApi().getBillingInfo(id).then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        print(list);
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
    EnrollmentInfo? selectedEnrollment = getSelectedEnrollmentInfo();
    BillingAssessmentInfo? selectedAssessment = getSelectedAssessmentInfo();
    return ListView(
      padding: const EdgeInsets.only(left: 5, right: 5),
      children: [
        const SizedBox(height: 8),
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  elevation: 4,
                  child: Container(
                    padding: const EdgeInsets.all(0),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
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

            // Adjust the spacing between the cards as needed
            Expanded(
              child: GestureDetector(
                onTap: () {
                  final provider =
                      Provider.of<NavigationProvider>(context, listen: false);

                  provider.setActiveNav('School Calendar');
                  // Add your desired action when the card is tapped here
                  widget.updateData(const SchoolCalendar(), "School Calendar");
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  elevation: 4,
                  child: Container(
                    padding: const EdgeInsets.all(0),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Image.asset(
                        //   'images/calendar1.png', // Replace with your own image URL
                        //   width: 80,
                        //   height: 80,
                        //   fit: BoxFit.contain,
                        // ),
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
                        )
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          elevation: 4,
          child: Padding(
            padding:
                const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
            child: SizedBox(
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
                      color: Colors
                          .blue[400], // Replace with your desired tinted color
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.filter_alt_outlined,
                            color: Colors.white),
                        const SizedBox(width: 5),
                        Text(
                          'Enrollment Info',
                          style: GoogleFonts.prompt(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const Spacer(),
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
                                underline: Container(), // To hide the underline
                                dropdownColor: Colors.blue[
                                    300], // Replace with your desired dropdown background color
                              )
                            : const CircularProgressIndicator(),
                      ],
                    ),
                  ),
                  if (selectedEnrollment != null)
                    Container(
                      padding: const EdgeInsets.all(0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.blue[
                            100], // Replace with your desired tinted color
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors
                                  .white, // Replace with your desired tinted color
                              borderRadius: BorderRadius.circular(0),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                            // child: Text(
                            //   selectedEnrollment.sectionname,
                            //   style: const TextStyle(
                            //     fontSize: 20.0,
                            //     fontWeight: FontWeight.bold,
                            //   ),
                            // ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Section',
                                    style: GoogleFonts.prompt(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      color: Colors
                                          .black87, // Replace with your desired text color
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                const Spacer(),
                                Expanded(
                                  child: Text(
                                    selectedEnrollment.sectionname,
                                    style: GoogleFonts.prompt(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
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
                                vertical: 10.0, horizontal: 10.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Grade Level',
                                    style: GoogleFonts.prompt(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      color: Colors
                                          .black87, // Replace with your desired text color
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                const Spacer(),
                                Expanded(
                                  child: Text(
                                    selectedEnrollment.levelname,
                                    style: GoogleFonts.prompt(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
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
                                  bottomRight: Radius.circular(5.0)),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Date Enrolled',
                                    style: GoogleFonts.prompt(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
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
                                    style: GoogleFonts.prompt(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          elevation: 4,
          child: Padding(
            padding:
                const EdgeInsets.only(left: 0, right: 0, bottom: 0, top: 0),
            child: SizedBox(
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
                        Text(
                          'Billing Assessment',
                          style: GoogleFonts.prompt(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const Spacer(),
                        selectedMonth.isNotEmpty
                            ? DropdownButton<String>(
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
                                          color: Colors
                                              .white, // Replace with your desired text color
                                        ),
                                      ),
                                    );
                                  },
                                ).toList(),
                                underline: Container(), // To hide the underline
                                dropdownColor: Colors.yellow[
                                    800], // Replace with your desired dropdown background color
                              )
                            : const CircularProgressIndicator(),
                      ],
                    ),
                  ),
                  if (selectedAssessment != null)
                    Container(
                      padding: const EdgeInsets.all(0),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(5.0),
                          bottomRight: Radius.circular(5.0),
                        ),
                        color: Colors.blue[
                            100], // Replace with your desired tinted color
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors
                                  .white, // Replace with your desired tinted color
                              borderRadius: BorderRadius.circular(0),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Particulars',
                                    style: GoogleFonts.prompt(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
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
                                    style: GoogleFonts.prompt(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
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
                                vertical: 10, horizontal: 10.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    selectedAssessment.particulars,
                                    style: GoogleFonts.prompt(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      color: Colors
                                          .black, // Replace with your desired text color
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    '₱ ${selectedAssessment.amount}', // Add the peso sign before the amount
                                    style: GoogleFonts.prompt(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
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
                                vertical: 10.0, horizontal: 10.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Total Assessment',
                                    style: GoogleFonts.prompt(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      color: Colors
                                          .black, // Replace with your desired text color
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    '\u20B1 $totalAss', // Add the peso sign before the amount
                                    style: GoogleFonts.prompt(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
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
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
