import 'dart:convert';

import 'package:essentiel/user/user_data.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/my_api.dart';
import '../user/user.dart';
import 'home.dart';

class SemesterInformation extends StatefulWidget {
  const SemesterInformation({super.key});

  @override
  State<SemesterInformation> createState() => _SemesterInformationState();
}

class _SemesterInformationState extends State<SemesterInformation> {
  User user = UserData.myUser;
  String selectedYear = '';
  List<String> years = [];
  var syid = 0;
  var levelid = 0;
  var sydesc = '';
  var levelname = '';
  var sectionname = '';
  var strand = 'Tech Voc';
  var adviser = 'Pitok Batolata';
  var id = '0';
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
      });
      getEnrollment();
    }
  }

  getEnrollment() async {
    await CallApi().getEnrollmentInfo(user.id).then((response) {
      setState(() {
        Iterable list = jsonDecode(response.body);
        print(list);
        enInfoData = list.map((model) {
          return EnrollmentInfo.fromJson(model);
        }).toList();

        for (var element in enInfoData) {
          years.add(element.sydesc);
          selectedYear = element.sydesc;
        }
        Set<String> uniqueSet = years.toSet();
        years = uniqueSet.toList();
        for (var yr in enInfoData) {
          if (yr.sydesc == selectedYear) {
            print("has match");
            syid = yr.syid;
            levelid = yr.levelid;
            sydesc = yr.sydesc;
            levelname = yr.levelname;
            sectionname = yr.sectionname;
            selectedEnrollment = getSelectedEnrollmentInfo();
          }
        }
      });
    });
  }

  EnrollmentInfo? getSelectedEnrollmentInfo() {
    if (selectedYear.isEmpty) return null;
    // Retrieve the enrollment info based on the selected year
    return enInfoData.firstWhere(
      (enrollment) => enrollment.sydesc == selectedYear,
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
          strandid: 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 10),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                                          selectedEnrollment =
                                              getSelectedEnrollmentInfo();
                                          // for (var yr in enInfoData) {
                                          //   if (yr.sydesc == selectedYear) {}
                                          // }
                                        });
                                      },
                                      items:
                                          years.map<DropdownMenuItem<String>>(
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
              const SizedBox(height: 20),
              Text(
                selectedEnrollment!.levelname,
                style: const TextStyle(
                  fontSize: 20,
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
              Row(
                children: [
                  const Expanded(child: Text('Grade Level:')),
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
                  ? const Row(
                      children: [
                        Expanded(child: Text('Strand:')),
                        Spacer(),
                        Expanded(
                            child: Text(
                          '',
                          textAlign: TextAlign.right,
                        )),
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
              selectedEnrollment!.levelid < 17
                  ? const Row(
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
                    )
                  : const SizedBox(
                      height: 0,
                    ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
