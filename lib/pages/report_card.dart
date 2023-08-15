import 'dart:convert';

import 'package:essentiel/models/enrollment_info.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:essentiel/api/my_api.dart';

class ReportCard extends StatefulWidget {
  const ReportCard({super.key});

  @override
  State<ReportCard> createState() => _ReportCardState();
}

class _ReportCardState extends State<ReportCard> {
  Color mainClr = Colors.white;
  @override
  void initState() {
    getUser();
    super.initState();
  }

  var id = '0';
  var syid = 0;
  var semid = 0;
  var gradelevel = 0;
  var sectionid = 0;
  var strand = 0;
  String selectedYear = '';
  String selectedSem = '1st Sem';
  List<String> years = [];
  List<String> sem = ['1st Sem', '2nd Sem'];
  List<Grades> data = [];
  List<Grades> finalGrade = [];
  List<EnrollmentInfo> enInfoData = [];
  List<Grades> concatenatedArray = [];

  Future<void> getUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final json = preferences.getString('studid');

    if (json != null) {
      setState(() {
        id = json;
      });
      getEnrollment();
    }
  }

  Future<void> getGrades(int index) async {
    Iterable gdList = [];
    Iterable gdFinal = [];

    await CallApi()
        .getStudGrade(id, gradelevel, syid, sectionid, strand, index)
        .then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        // print(list);
        for (var gd in list) {
          // print(gd['grades']);
          gdList = gd['grades'];
          // print(gdList);
          // print(gd['finalgrade']);
          if (gradelevel < 17) {
            gdFinal = gd['finalgrade'];
          }
        }

        if (gradelevel < 17) {
          data = gdList.map((model) {
            return Grades.fromJson(model);
          }).toList();
        } else {
          data = gdList.map((model) {
            return Grades(
              subjcode: model['subjcode'] ?? '',
              subjdesc: model['subjdesc'] ?? '',
              q1: model['prelemgrade'] ?? 0,
              q2: model['midtermgrade'] ?? 0,
              q3: model['prefigrade'] ?? 0,
              q4: model['finalgrade'] ?? 0,
              finalrating: model['finalgrade'] ?? '',
              actiontaken: model['actiontaken'] ?? '',
            );
          }).toList();
        }

        // if (gradelevel >= 17) {
        //   finalGrade = gdList.map((ave) {
        //     return ave['semid'].toString() == index.toString()
        //         ? Grades(
        //             subjcode: ave['subjcode'],
        //             subjdesc: ave['subjdesc'],
        //             q1: ave['prelemgrade'],
        //             q2: ave['midtermgrade'],
        //             q3: ave['prefigrade'],
        //             q4: ave['finalgrade'],
        //             finalrating: ave['finalgrade'],
        //             actiontaken: ave['actiontaken'],
        //           )
        //         : Grades(
        //             subjcode: '',
        //             q1: '',
        //             q2: '',
        //             q3: '',
        //             q4: '',
        //             finalrating: '',
        //             actiontaken: '',
        //             subjdesc: '');
        //   }).toList();
        // }

        if (gradelevel == 14 || gradelevel == 15) {
          finalGrade = gdFinal.map((ave) {
            return ave['semid'].toString() == index.toString()
                ? Grades.parseAverage(ave)
                : Grades(
                    subjcode: '',
                    q1: '',
                    q2: '',
                    q3: '',
                    q4: '',
                    finalrating: '',
                    actiontaken: '',
                    subjdesc: '');
          }).toList();
        }
        //  else {
        //   finalGrade = gdFinal.map((ave) {
        //     return Grades.parseAverage(ave);
        //   }).toList();
        // }

        semid = index;
        concatenatedArray = [...data, ...finalGrade];
        concatenatedArray = concatenatedArray
            .where((grade) => grade.subjcode.isNotEmpty)
            .toList();
      });
    });
  }

  getEnrollment() async {
    await CallApi().getEnrollmentInfo(id).then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        // print(list);
        enInfoData = list.map((model) {
          return EnrollmentInfo.fromJson(model);
        }).toList();

        for (var element in enInfoData) {
          years.add(element.sydesc);
        }
        Set<String> uniqueSet = years.toSet();
        years = uniqueSet.toList();

        selectedYear = enInfoData[enInfoData.length - 1].sydesc;
        var lastindex = enInfoData[enInfoData.length - 1];
        // print(lastindex.levelname);
        setState(() {
          syid = lastindex.syid;
          semid = 1;
          gradelevel = lastindex.levelid;
          sectionid = lastindex.sectionid;
          strand = lastindex.strandid;
        });
        getGrades(1);
        // for (var yr in enInfoData) {
        //   if (yr.sydesc == selectedYear) {
        //     // print("has match");
        //     setState(() {
        //       syid = yr.syid;
        //       semid = 1;
        //       gradelevel = yr.levelid;
        //       sectionid = yr.sectionid;
        //       strand = yr.strandid;
        //     });
        //     getGrades(1);
        //   }
        // }
      });
    });
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
          // dropdown yearly
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            elevation: 4,
            child: SizedBox(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 2.0, horizontal: 10.0),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
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
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedYear = newValue!;
                                    for (var yr in enInfoData) {
                                      if (yr.sydesc == selectedYear) {
                                        syid = yr.syid;
                                        selectedSem = sem[0];
                                        gradelevel = yr.levelid;
                                        sectionid = yr.sectionid;
                                        strand = yr.strandid;
                                        getGrades(yr.semid);
                                      }
                                    }
                                  });
                                },
                                items: years.map<DropdownMenuItem<String>>(
                                  (String year) {
                                    return DropdownMenuItem<String>(
                                      value: year,
                                      child: Text(
                                        year,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.bold,
                                          color: selectedYear == year
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    );
                                  },
                                ).toList(),

                                underline: Container(), // To hide the underline
                                dropdownColor: Colors.indigo[
                                    300], // Replace with your desired dropdown background color
                                style: const TextStyle(
                                  color: Colors
                                      .white, // Replace with your desired text color
                                ),
                              )
                            : const CircularProgressIndicator(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // dropdown semester
          if (gradelevel == 14 || gradelevel == 15 || gradelevel >= 17)
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
                                        var index =
                                            sem.indexOf(selectedSem) + 1;
                                        getGrades(index);
                                      });
                                    },
                                    items: sem.map<DropdownMenuItem<String>>(
                                      (String semes) {
                                        return DropdownMenuItem<String>(
                                          value: semes,
                                          child: Text(
                                            semes,
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
          const SizedBox(
            height: 10,
          ),
          // Datatable for grades
          DataTable(
            columnSpacing: 15.0,
            columns: [
              const DataColumn(label: Text('Subjects')),
              DataColumn(
                label: MergeSemantics(
                  child: SizedBox(
                    width: 112, // Adjust the width value as needed
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (gradelevel >= 17 || gradelevel == 0)
                          const Text(
                            'Subject Description',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        if (gradelevel < 17 && gradelevel != 0)
                          const Text(
                            'Periodic Ratings',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(fontSize: 12),
                          ),
                        if (gradelevel < 17 && gradelevel != 0)
                          const Divider(
                            height: 5,
                            thickness: 1,
                            color: Colors.grey,
                          ),
                        if (gradelevel == 14 ||
                            gradelevel == 15 && gradelevel != 0)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              if (semid == 1) const Text('Q1'),
                              if (semid == 1) const Text('Q2'),
                              if (semid == 2) const Text('Q3'),
                              if (semid == 2) const Text('Q4'),
                            ],
                          ),
                        if (gradelevel != 14 &&
                            gradelevel != 15 &&
                            gradelevel != 17 &&
                            gradelevel < 17 &&
                            gradelevel != 0)
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text('Q1'),
                              Text('Q2'),
                              Text('Q3'),
                              Text('Q4'),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              const DataColumn(
                label: Expanded(
                  child: Text(
                    'Final\nRating',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ),
              const DataColumn(
                label: Expanded(
                  child: Text(
                    'Action \nTaken',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ),
            ],
            rows: concatenatedArray.asMap().entries.map((entry) {
              final index = entry.key;
              final grade = entry.value;
              final isEvenRow = index % 2 == 0;
              final rowColor = isEvenRow ? Colors.grey.shade200 : Colors.white;

              return DataRow(
                  color: MaterialStateColor.resolveWith((states) => rowColor),
                  cells: [
                    DataCell(
                      Text(
                        grade.subjcode,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    DataCell(
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (gradelevel >= 17)
                            Text(
                              grade.subjdesc,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          // Row(
                          //   mainAxisAlignment:
                          //       MainAxisAlignment.spaceEvenly,
                          //   children: [
                          //     if (semid == 1 && grade.q1 != "null")
                          //       Text(grade.q1),
                          //     if (semid == 1 && grade.q2 != "null")
                          //       Text(grade.q2),
                          //     if (semid == 1 && grade.q3 != "null")
                          //       Text(grade.q3),
                          //     if (semid == 2 && grade.q1 != "null")
                          //       Text(grade.q1),
                          //     if (semid == 2 && grade.q2 != "null")
                          //       Text(grade.q2),
                          //     if (semid == 2 && grade.q3 != "null")
                          //       Text(grade.q3),
                          //   ],
                          // ),

                          if (gradelevel == 14 || gradelevel == 15)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                if (semid == 1 && grade.q1 != "null")
                                  Text(grade.q1),
                                if (semid == 1 && grade.q2 != "null")
                                  Text(grade.q2),
                                if (semid == 2 && grade.q3 != "null")
                                  Text(grade.q3),
                                if (semid == 2 && grade.q4 != "null")
                                  Text(grade.q4),
                              ],
                            ),
                          if (gradelevel != 14 &&
                              gradelevel != 15 &&
                              gradelevel != 17 &&
                              gradelevel < 17)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                if (grade.q1 != "null") Text(grade.q1),
                                if (grade.q2 != "null") Text(grade.q2),
                                if (grade.q3 != "null") Text(grade.q3),
                                if (grade.q4 != "null") Text(grade.q4),
                              ],
                            ),
                        ],
                      ),
                    ),
                    grade.finalrating != "null"
                        ? DataCell(Text(grade.finalrating))
                        : const DataCell(Text('')),
                    DataCell(
                      Text(grade.actiontaken.toString().isNotEmpty
                          ? grade.actiontaken
                          : ''),
                    ),
                  ]);
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class Grades {
  final String subjcode;
  final String subjdesc;
  final String q1;
  final String q2;
  final String q3;
  final String q4;
  final String finalrating;
  final String actiontaken;

  Grades({
    required this.subjcode,
    required this.subjdesc,
    required this.q1,
    required this.q2,
    required this.q3,
    required this.q4,
    required this.finalrating,
    required this.actiontaken,
  });

  factory Grades.fromJson(Map json) {
    var subjcode = json['subjcode'] ?? '';
    var subjdesc = json['subjdesc'] ?? '';
    var q1 = json['q1'].toString();
    var q2 = json['q2'].toString();
    var q3 = json['q3'].toString();
    var q4 = json['q4'].toString();
    var finalrating = json['finalrating'].toString();
    var actiontaken = json['actiontaken'] ?? '';
    return Grades(
        subjcode: subjcode,
        q1: q1,
        q2: q2,
        q3: q3,
        q4: q4,
        finalrating: finalrating,
        actiontaken: actiontaken,
        subjdesc: subjdesc);
  }

  factory Grades.parseAverage(Map json) {
    var subjcode = json['subjdesc'] ?? '';
    var q1 = json['q1'].toString();
    var q2 = json['q2'].toString();
    var q3 = json['q3'].toString();
    var q4 = json['q4'].toString();
    var finalrating = json['finalrating'].toString();
    var actiontaken = json['actiontaken'] ?? '';
    return Grades(
        subjcode: subjcode,
        q1: q1,
        q2: q2,
        q3: q3,
        q4: q4,
        finalrating: finalrating,
        actiontaken: actiontaken,
        subjdesc: subjcode);
  }
}
