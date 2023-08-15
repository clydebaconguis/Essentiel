import 'dart:convert';

import 'package:essentiel/models/enrollment_info.dart';
import 'package:essentiel/user/user_data.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:essentiel/api/my_api.dart';
import 'package:essentiel/user/user.dart';

class SemesterInformation extends StatefulWidget {
  const SemesterInformation({super.key});

  @override
  State<SemesterInformation> createState() => _SemesterInformationState();
}

class _SemesterInformationState extends State<SemesterInformation> {
  User user = UserData.myUser;
  String selectedYear = '';
  List<String> years = [];
  var syid = 1;
  var semid = 1;
  var levelid = 0;
  var sydesc = '';
  var levelname = '';
  var sectionname = '';
  var strand = 'Tech Voc';
  var adviser = 'Pitok Batolata';
  var id = '0';
  String selectedSem = '';
  List<String> semesters = [];
  List<EnrollmentInfo> enInfoData = [];

  EnrollmentInfo? selectedEnrollment = EnrollmentInfo(
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
    courseabrv: '',
  );

  @override
  void initState() {
    getUser();
    super.initState();
  }

  getUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final json = preferences.getString('user');

    if (json != null) {
      setState(() {
        user = User.fromJson(jsonDecode(json) as Map);
        levelid = user.levelid;
      });
      getEnrollment();
    }
  }

  getEnrollment() async {
    await CallApi().getEnrollmentInfo(user.id).then((response) {
      setState(() {
        Iterable list = jsonDecode(response.body);
        // print(list);
        enInfoData = list.map((model) {
          return EnrollmentInfo.fromJson(model);
        }).toList();

        for (var element in enInfoData) {
          years.add(element.sydesc);
          semesters.add(element.semester);
        }
        Set<String> uniqueSet = years.toSet();
        years = uniqueSet.toList();
        selectedYear = enInfoData[enInfoData.length - 1].sydesc;
        selectedSem = semesters[0];
        var lastindex = enInfoData[enInfoData.length - 1];
        selectedYear = lastindex.sydesc;
        syid = lastindex.syid;
        semid = lastindex.semid;
        levelid = lastindex.levelid;

        selectedEnrollment = getSelectedEnrollmentInfo();

        // for (var yr in enInfoData) {
        //   if (yr.sydesc == selectedYear &&
        //       yr.semid == semid &&
        //       yr.syid == syid) {
        //     print("has match");
        //     syid = yr.syid;
        //     levelid = yr.levelid;
        //     sydesc = yr.sydesc;
        //     levelname = yr.levelname;
        //     sectionname = yr.sectionname;

        //   }
        // }
      });
    });
  }

  EnrollmentInfo? getSelectedEnrollmentInfo() {
    if (selectedYear.isEmpty) return null;
    // Retrieve the enrollment info based on the selected year
    return enInfoData.firstWhere(
      (enrollment) =>
          enrollment.sydesc == selectedYear &&
          enrollment.semid == semid &&
          enrollment.syid == syid,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.only(left: 10, right: 10),
        children: [
          const SizedBox(
            height: 8,
          ),
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
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
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.indigo[
                            800], // Replace with your desired tinted color
                      ),
                      child: Row(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.filter_alt_outlined,
                                  color: Colors.white),
                              const SizedBox(width: 10),
                              Text(
                                'School Year',
                                style: GoogleFonts.prompt(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          selectedYear.isNotEmpty
                              ? DropdownButton<String>(
                                  value: selectedYear,
                                  hint: const Text('Select Year'),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedYear = newValue!;

                                      for (var yr in enInfoData) {
                                        if (yr.sydesc == selectedYear) {
                                          // print(yr.sydesc);
                                          // print(yr.syid);
                                          // print(yr.levelname);
                                          // print(yr.levelid);
                                          // print(yr.sectionname);
                                          // print(yr.sectionid);
                                          // print(yr.semid);
                                          syid = yr.syid;
                                          semid = yr.semid;
                                          levelid = yr.levelid;
                                        }
                                      }
                                      selectedEnrollment =
                                          getSelectedEnrollmentInfo();
                                    });
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
                                  underline:
                                      Container(), // To hide the underline
                                  dropdownColor: Colors.indigo[
                                      400], // Replace with your desired dropdown background color
                                )
                              : const CircularProgressIndicator(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (levelid == 14 || levelid == 15 || levelid >= 17)
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
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
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          color: Colors.blue[
                              400], // Replace with your desired tinted color
                        ),
                        child: Row(
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.filter_alt_outlined,
                                    color: Colors.white),
                                const SizedBox(width: 10),
                                Text(
                                  'Semester',
                                  style: GoogleFonts.prompt(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            selectedSem.isNotEmpty
                                ? DropdownButton<String>(
                                    value: selectedSem,
                                    hint: const Text('Select Sem'),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedSem = newValue!;
                                        for (var each in enInfoData) {
                                          if (each.semester == newValue) {
                                            syid = each.syid;
                                            semid = each.semid;
                                            // print("$syid $semid");
                                            selectedEnrollment =
                                                getSelectedEnrollmentInfo();
                                            break;
                                          }
                                        }
                                      });
                                    },
                                    items:
                                        semesters.map<DropdownMenuItem<String>>(
                                      (String semes) {
                                        return DropdownMenuItem<String>(
                                          value: semes,
                                          child: Text(
                                            semes.toString(),
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
                                          .white, // Replace with your desired text color
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
                    ],
                  ),
                ),
              ),
            ),
          const SizedBox(height: 20),
          Text(
            selectedEnrollment!.levelname,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Expanded(child: Text('First Name:')),
              const Spacer(),
              Expanded(
                  child: Text(
                user.firstname,
                textAlign: TextAlign.right,
              )),
            ],
          ),
          const Divider(height: 20),
          Row(
            children: [
              const Expanded(child: Text('Middle Name:')),
              const Spacer(),
              Expanded(
                  child: Text(
                user.middlename,
                textAlign: TextAlign.right,
              )),
            ],
          ),
          const Divider(
            height: 20,
          ),
          Row(
            children: [
              const Expanded(child: Text('Last Name:')),
              const Spacer(),
              Expanded(
                  child: Text(
                user.lastname,
                textAlign: TextAlign.right,
              )),
            ],
          ),
          const Divider(),
          Row(
            children: [
              const Expanded(child: Text('ID Numer:')),
              const Spacer(),
              Expanded(
                  child: Text(
                user.sid,
                textAlign: TextAlign.right,
              )),
            ],
          ),
          const Divider(),
          if (selectedEnrollment!.levelid >= 17)
            Row(
              children: [
                const Expanded(child: Text('Course:')),
                const Spacer(),
                Expanded(
                    child: Text(
                  selectedEnrollment!.courseabrv,
                  textAlign: TextAlign.right,
                )),
              ],
            ),
          if (selectedEnrollment!.levelid >= 17) const Divider(),
          Row(
            children: [
              Expanded(
                  child: Text(selectedEnrollment!.levelid < 17
                      ? "Grade Level:"
                      : "Year Level")),
              const Spacer(),
              Expanded(
                  child: Text(
                selectedEnrollment!.levelname,
                textAlign: TextAlign.right,
              )),
            ],
          ),
          const Divider(),
          Row(
            children: [
              const Expanded(child: Text('School Year:')),
              const Spacer(),
              Expanded(
                  child: Text(
                selectedEnrollment!.sydesc,
                textAlign: TextAlign.right,
              )),
            ],
          ),
          const Divider(),
          if (selectedEnrollment!.levelid == 14 ||
              selectedEnrollment!.levelid == 15 ||
              selectedEnrollment!.levelid >= 17)
            Row(
              children: [
                const Expanded(child: Text('Semester:')),
                const Spacer(),
                Expanded(
                    child: Text(
                  selectedEnrollment!.semester,
                  textAlign: TextAlign.right,
                )),
              ],
            ),
          if (selectedEnrollment!.levelid == 14 ||
              selectedEnrollment!.levelid == 15 ||
              selectedEnrollment!.levelid >= 17)
            const Divider(),
          Row(
            children: [
              const Expanded(child: Text('Section:')),
              const Spacer(),
              Expanded(
                  child: Text(
                selectedEnrollment!.sectionname,
                textAlign: TextAlign.right,
              )),
            ],
          ),
          const Divider(),
          (selectedEnrollment!.levelid == 14 ||
                  selectedEnrollment!.levelid == 15)
              ? Row(
                  children: [
                    const Expanded(
                      child: Text('Strand:'),
                    ),
                    const Spacer(),
                    Expanded(
                      child: Text(
                        selectedEnrollment!.strandcode,
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                )
              : const SizedBox(
                  height: 0,
                ),
          (selectedEnrollment!.levelid == 14 ||
                  selectedEnrollment!.levelid == 15)
              ? const Divider()
              : const SizedBox(
                  height: 0,
                ),
          if (selectedEnrollment!.levelid < 17)
            const Row(
              children: [
                Expanded(child: Text('Adviser:')),
                Spacer(),
                Expanded(
                  child: Text(
                    '',
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          if (selectedEnrollment!.levelid < 17) const Divider(),
        ],
      ),
    );
  }
}
