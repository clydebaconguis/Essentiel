import 'dart:convert';

import 'package:essentiel/user/user_data.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/my_api.dart';
import '../user/user.dart';
import 'home.dart';

class ClassSchedPage extends StatefulWidget {
  const ClassSchedPage({super.key});

  @override
  State<ClassSchedPage> createState() => _ClassSchedPageState();
}

// class Yearly {
//   final int syid;
//   final String year;
//
//   Yearly({
//     required this.syid,
//     required this.year,
//   });
// }

class _ClassSchedPageState extends State<ClassSchedPage> {
  User user = UserData.myUser;
  String id = '0';
  String selectedSem = '1st Sem';
  List<String> sem = ['1st Sem', '2nd Sem'];
  int syid = 0;
  int sectionid = 0;
  int levelid = 0;
  int semid = 0;
  String selectedMonth = '';
  String selectedYear = '';
  List<String> months = [];
  List<String> years = [];
  // List<Yearly> years2 = [];
  List<SchedData> listOfSched = [];
  List<SchedItem> listOfItem2 = [];
  List<SchedItem> listOfItem3 = [];
  List<EnrollmentInfo> enInfoData = [];

  getSchedByMonth() {
    Set<String> uniqueSet = months.toSet();
    months = uniqueSet.toList();
    if (selectedMonth.isEmpty) {
      return null;
    }
    // Retrieve the assessment info based on the selected year
    else {
      listOfItem3.clear();
      for (var element in listOfItem2) {
        if (element.month.contains(selectedMonth)) {
          setState(() {
            listOfItem3.add(
              SchedItem(
                month: element.month,
                start: element.start,
                end: element.end,
                subject: element.subject,
                room: element.room,
                teacher: element.teacher,
              ),
            );
          });
        }
      }
      // return listOfSched.firstWhere(
      //   (item) => item.day.toLowerCase().contains(selectedMonth.toLowerCase()),
      //   orElse: () => SchedData(day: '', sched: []),
      // );
    }
  }

  getStudSchedule(int index) async {
    months.clear();
    selectedMonth = '';
    listOfItem2.clear();
    List<SchedItem> listOfItem = [];
    await CallApi()
        .getSchedule(user.id, syid, index, sectionid, levelid)
        .then((response) {
      Iterable list = json.decode(response.body);
      // print(list);
      setState(() {
        for (var element in list) {
          var ll = element['schedule'];
          print(ll);
          for (var el in ll) {
            listOfItem.clear();
            if (el['day'] != null && el['sched'] != null) {
              // var day = json.decode(el['day']);
              var sched = el['sched'];
              print(sched);
              print(el['day']);
              if (sched.isNotEmpty || sched != null) {
                for (var item in sched) {
                  if (item['start'] != null) {
                    // print(item['start']);
                    var start = item['start'] ?? '';
                    var end = item['end'] ?? '';
                    var subject = item['subject'] ?? '';
                    var room = item['room'] ?? '';
                    var teacher = item['teacher'] ?? '';
                    listOfItem.add(
                      SchedItem(
                          month: el['day'],
                          start: start,
                          end: end,
                          subject: subject,
                          room: room,
                          teacher: teacher),
                    );
                    listOfItem2.add(
                      SchedItem(
                          month: el['day'],
                          start: start,
                          end: end,
                          subject: subject,
                          room: room,
                          teacher: teacher),
                    );
                  }
                }
                months.add(el['day']);
              }
            }
            listOfSched.add(SchedData(day: el['day'], sched: listOfItem));
          }

          semid = index;
          print(listOfSched.length);
          selectedMonth = listOfSched[0].day;
          print(selectedMonth);
          getSchedByMonth();
        }
      });
    });
  }

  getEnrollment() async {
    await CallApi().getEnrollmentInfo(user.id).then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        print(list);
        enInfoData = list.map((model) {
          return EnrollmentInfo.fromJson(model);
        }).toList();

        for (var element in enInfoData) {
          years.add(element.sydesc);
        }
        Set<String> uniqueSet = years.toSet();
        years = uniqueSet.toList();
        selectedYear = enInfoData[enInfoData.length - 1].sydesc;
        for (var yr in enInfoData) {
          if (yr.sydesc == selectedYear) {
            print("has match");
            setState(() {
              syid = yr.syid;
              semid = 1;
              sectionid = yr.sectionid;
              levelid = yr.levelid;
            });
            getStudSchedule(1);
            break;
            // print(selectedMonth);
            // getSchedByMonth();
          }
        }
      });
    });
  }

  getUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final json = preferences.getString('user');

    setState(() {
      user = json == null ? UserData.myUser : User.fromJson(jsonDecode(json));
    });
    getEnrollment();
  }

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
      ),
    );
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    EnrollmentInfo? selectedEnrollment = getSelectedEnrollmentInfo();
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            // enrollment info dropdown yearly
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
                            const Row(
                              children: [
                                Icon(Icons.filter_alt_outlined,
                                    color: Colors.white),
                                SizedBox(width: 10),
                                Text(
                                  'School Year',
                                  style: TextStyle(
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
                                            syid = yr.syid;
                                            sectionid = yr.sectionid;
                                            levelid = yr.levelid;
                                            selectedMonth =
                                                listOfItem2[0].month;
                                            print(selectedMonth);
                                            getStudSchedule(1);
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
                                        500], // Replace with your desired dropdown background color
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
                  padding: const EdgeInsets.only(
                      left: 0, right: 0, top: 0, bottom: 0),
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
                              const Row(
                                children: [
                                  Icon(Icons.filter_alt_outlined,
                                      color: Colors.white),
                                  SizedBox(width: 10),
                                  Text(
                                    'Semester',
                                    style: TextStyle(
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
                                          getStudSchedule(index);
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
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 2.0,
                        horizontal: 10.0,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.blue[600],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.filter_alt_outlined,
                              color: Colors.white),
                          const SizedBox(width: 10),
                          const Text(
                            'Class Schedule',
                            style: TextStyle(
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
                                      getSchedByMonth();
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
                                          ),
                                        ),
                                      );
                                    },
                                  ).toList(),
                                  style: const TextStyle(
                                    color: Colors.black,
                                  ),
                                  underline: Container(),
                                  dropdownColor: Colors.blue[400],
                                )
                              : const CircularProgressIndicator(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            DataTable(
              columnSpacing: 20,
              columns: const [
                DataColumn(label: Text('Time')),
                DataColumn(
                  label: Text(
                    'Room',
                    textAlign: TextAlign.center,
                  ),
                ),
                DataColumn(label: Text('Subject / Teacher')),
              ],
              rows: listOfItem3.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final isEvenRow = index % 2 == 0;
                final rowColor =
                    isEvenRow ? Colors.grey.shade200 : Colors.white;

                return DataRow(
                    color: MaterialStateColor.resolveWith((states) => rowColor),
                    cells: [
                      DataCell(
                        Column(
                          children: [
                            Text(
                              item.start,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            Text(
                              item.end,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                      DataCell(Text(item.room)),
                      DataCell(
                        Text(
                          ' ${item.subject} / ${item.teacher}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ]);
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class ScheduleInfo {
  final String id;
  final String name;
  final List<SchedData> schedule;

  ScheduleInfo({
    required this.id,
    required this.name,
    required this.schedule,
  });

  factory ScheduleInfo.fromJson(Map json) {
    var id = json['id'] ?? 0;
    var name = json['amount'] ?? '';

    var ll = List.from(json['schedule']);

    List<SchedData> schDataList = ll.map((i) => SchedData.fromJson(i)).toList();
    return ScheduleInfo(id: id, name: name, schedule: schDataList);
  }
}

class SchedData {
  final String day;
  final List<SchedItem> sched;

  SchedData({
    required this.day,
    required this.sched,
  });

  factory SchedData.fromJson(Map json) {
    var day = json['day'] ?? '';

    var ll = List.from(json['sched']);

    // List<SchedItem> sched = json['sched'] ?? List<SchedItem>;
    List<SchedItem> schDataList = ll.map((i) => SchedItem.fromJson(i)).toList();
    return SchedData(day: day, sched: schDataList);
  }
}

class SchedItem {
  final String month;
  final String start;
  final String end;
  final String subject;
  final String room;
  final String teacher;

  SchedItem({
    required this.month,
    required this.start,
    required this.end,
    required this.subject,
    required this.room,
    required this.teacher,
  });

  factory SchedItem.fromJson(Map json) {
    var start = json['start'] ?? '';
    var end = json['end'] ?? '';
    var subject = json['subject'] ?? '';
    var room = json['room'] ?? '';
    var teacher = json['teacher'] ?? '';

    // List<SchedItem> sched = json['sched'] ?? List<SchedItem>;
    return SchedItem(
        start: start,
        end: end,
        subject: subject,
        room: room,
        teacher: teacher,
        month: '');
  }
}
