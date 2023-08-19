import 'dart:convert';
import 'package:essentiel/models/enrollment_info.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:essentiel/api/my_api.dart';

class SchoolCalendar extends StatefulWidget {
  const SchoolCalendar({super.key});

  @override
  State<SchoolCalendar> createState() => _SchoolCalendarState();
}

class _SchoolCalendarState extends State<SchoolCalendar> {
  var id = '0';
  var syid = 0;
  String selectedYear = '';
  List<String> years = [];
  List<Event> events = [];
  List<EnrollmentInfo> enInfoData = [];
  late List<Appointment> _appointments = [];

  // String json =
  //     '[{"id":1,"title":"Test","venue":"AVR","startTime":"2023-07-18 00:00:00","endTime":"2023-07-19 00:00:00","time":"12:00 AM-12:00 AM"},{"id":2,"title":"Adam","venue":"Mat\'s House","startTime":"2023-02-11 00:00:00","endTime":"2023-02-12 00:00:00","time":"12:00 AM-12:00 AM"},{"id":3,"title":"ASd","venue":"ASD","startTime":"2023-07-10 00:00:00","endTime":"2023-07-11 00:00:00","time":"12:00 AM-12:00 AM"},{"id":4,"title":"ASd","venue":"ASD","startTime":"2023-02-10 00:00:00","endTime":"2023-02-11 00:00:00","time":"12:00 AM-12:00 AM"},{"id":5,"title":"ASd","venue":"ASD","startTime":"2023-02-10 00:00:00","endTime":"2023-02-11 00:00:00","time":"12:00 AM-12:00 AM"},{"id":6,"title":"New Year","venue":"Anywhere","startTime":"2022-12-31 00:00:00","endTime":"2023-01-02 00:00:00","time":"12:00 AM-12:00 AM"}]';

  @override
  void initState() {
    getUser();
    super.initState();
  }

  List<Appointment> _getAppointments() {
    return events.map((event) {
      // print("sdfksldjf");
      // print(event.id);
      return Appointment(
        startTime: event.startTime,
        endTime: event.endTime,
        subject: event.title,
        color: Colors.blue, // Customize the event color as desired
      );
    }).toList();
  }

  List<TimeRegion> _getSpecialRegions() {
    List<TimeRegion> specialRegions = [];

    for (Appointment appointment in _appointments) {
      specialRegions.add(TimeRegion(
        startTime: appointment.startTime,
        endTime: appointment.endTime,
        enablePointerInteraction: false,
        textStyle: const TextStyle(color: Colors.white),
        color: Colors.blue, // Customize the event color as desired
      ));
    }

    return specialRegions;
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
            getEvents();
          }
        }
      });
    });
  }

  getEvents() async {
    await CallApi().getEvents(syid).then((response) {
      setState(() {
        Iterable ll = jsonDecode(response.body);
        events = (ll as List<dynamic>).map((e) {
          // print(e['id']);
          return Event(
            id: e['id'],
            title: e['title'],
            venue: e['venue'],
            startTime: DateTime.parse(e['startTime']),
            endTime: DateTime.parse(e['endTime']),
            time: e['time'],
          );
        }).toList();
        _appointments = _getAppointments();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
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
                                            syid = yr.syid;
                                            getEvents();
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
            events.isNotEmpty
                ? Expanded(
                    flex: 2,
                    child: SfCalendar(
                      view: CalendarView.month,
                      initialSelectedDate: DateTime.now(),
                      dataSource: _AppointmentDataSource(_appointments),
                      appointmentBuilder: appointmentBuilder,
                      onTap: onTapCalendarCell,
                      specialRegions: _getSpecialRegions(),
                    ),
                  )
                : Expanded(
                    flex: 2,
                    child: SfCalendar(
                      view: CalendarView.month,
                      initialSelectedDate: DateTime.now(),
                      dataSource: _AppointmentDataSource(_appointments),
                      appointmentBuilder: appointmentBuilder,
                      onTap: onTapCalendarCell,
                      specialRegions: _getSpecialRegions(),
                    ),
                  ),
            events.isNotEmpty
                ? Expanded(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            "Events",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: events.length,
                            itemBuilder: (context, index) {
                              Event event = events[index];
                              return ListTile(
                                title: Text(event.title),
                                subtitle: Text(event.venue),
                                trailing: Text(event.time),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox(
                    height: 0,
                  )
          ],
        ),
      ),
    );
  }

  void onTapCalendarCell(CalendarTapDetails details) {
    if (details.appointments != null && details.appointments!.isNotEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          List<Event> events2 = details.appointments!.map((appointment) {
            return events.firstWhere((event) =>
                event.title == appointment.subject &&
                event.startTime == appointment.startTime &&
                event.endTime == appointment.endTime);
          }).toList();

          return AlertDialog(
            title: const Text('Event Details'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: events2.map((event) {
                return ListTile(
                  title: Text(event.title),
                  subtitle: Text(event.venue),
                  trailing: Text(event.time),
                );
              }).toList(),
            ),
          );
        },
      );
    }
  }

  Widget appointmentBuilder(
      BuildContext context, CalendarAppointmentDetails details) {
    if (details.appointments.length == 1) {
      return Container(
        decoration: BoxDecoration(
          color: details.appointments.first.color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            details.appointments.first.subject,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    } else if (details.appointments.length > 1) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            '+${details.appointments.length}',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}

class Event {
  final int id;
  final String title;
  final String venue;
  final DateTime startTime;
  final DateTime endTime;
  final String time;

  Event({
    required this.id,
    required this.title,
    required this.venue,
    required this.startTime,
    required this.endTime,
    required this.time,
  });
}

class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}
