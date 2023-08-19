import 'dart:convert';

import 'package:essentiel/models/enrollment_info.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/material.dart';
import 'package:essentiel/api/my_api.dart';

class Attendance extends StatefulWidget {
  const Attendance({super.key});

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  var id = '0';
  var syid = 0;
  var levelid = 0;
  String selectedYear = '';
  List<String> years = [];
  List<CustomEvent> events = [];
  List<EnrollmentInfo> enInfoData = [];
  late CustomEvent selectedEvent = CustomEvent(
      isPresent: 0,
      subject: '',
      startTime: DateTime.now(),
      endTime: DateTime.now(),
      color: Colors.white);

  @override
  void initState() {
    getUser();
    super.initState();
  }

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

  getEnrollment() async {
    await CallApi().getEnrollmentInfo(id).then((response) {
      setState(() {
        Iterable list = jsonDecode(response.body);
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
        for (var yr in enInfoData) {
          if (yr.sydesc == selectedYear) {
            // print("has match");
            syid = yr.syid;
            levelid = yr.levelid;
            getAttendance();
          }
        }
      });
    });
  }

  getAttendance() async {
    await CallApi().getAttendance(id, syid, levelid).then((response) {
      if (mounted) {
        setState(() {
          events.clear();
          selectedEvent = CustomEvent(
              isPresent: 0,
              subject: '',
              startTime: DateTime.now(),
              endTime: DateTime.now(),
              color: Colors.white);
          Iterable ll = jsonDecode(response.body);
          // print(ll);
          events = ll.map((data) {
            String tdate = data['tdate'];
            DateTime dateTime = DateTime.parse(tdate);

            return CustomEvent(
              isPresent: data['present'],
              subject: data['attday'],
              startTime: dateTime,
              endTime: dateTime.add(const Duration(days: 1)),
              color: Colors.blue,
              // Customize the event color as per your preference
            );
          }).toList();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          const SizedBox(
            height: 8,
          ),
          Card(
            margin: const EdgeInsets.only(left: 10, right: 10),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.only(left: 0, right: 0),
              child: SizedBox(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
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
                                          syid = yr.syid;
                                          levelid = yr.levelid;
                                          getAttendance();
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
                                  underline:
                                      Container(), // To hide the underline
                                  dropdownColor: Colors.blue[
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
          Expanded(
            child: SfCalendar(
              view: CalendarView.month,
              dataSource: _AppointmentDataSource(events),
              onTap: (CalendarTapDetails details) {
                if (details.targetElement == CalendarElement.calendarCell) {
                  // Get the selected event for the tapped date
                  DateTime tappedDate = details.date!;
                  selectedEvent = events.firstWhere(
                    (event) =>
                        event.startTime.year == tappedDate.year &&
                        event.startTime.month == tappedDate.month &&
                        event.startTime.day == tappedDate.day,
                    orElse: () => CustomEvent(
                        subject: ' subject',
                        startTime: DateTime.now(),
                        endTime: DateTime.now(),
                        color: Colors.grey,
                        isPresent: 0),
                  );
                  setState(() {}); // Update the widget to show the card
                }
              },
            ),
          ),
          if (selectedEvent.subject.isNotEmpty) ...[
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Attendance',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      selectedEvent.startTime.toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      selectedEvent.isPresent.toString() == '1'
                          ? 'Present'
                          : 'Absent',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class CustomEvent extends Appointment {
  final int isPresent;
  CustomEvent({
    required this.isPresent,
    required String subject,
    required DateTime startTime,
    required DateTime endTime,
    required Color color,
  }) : super(
          startTime: startTime,
          endTime: endTime,
          subject: subject,
          color: color,
        );
}

class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}
