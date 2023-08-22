import 'dart:async';

import 'package:essentiel/components/copyright.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeDio extends StatefulWidget {
  const HomeDio({super.key});

  @override
  State<HomeDio> createState() => _HomeDioState();
}

class _HomeDioState extends State<HomeDio> {
  String _currentDay = '';
  String _currentTime = '';
  String _currentDate = '';

  final List<EmployeeAttendance> _employeeAttendanceList = [
    EmployeeAttendance('clyde', true),
    EmployeeAttendance('echem', false),
    EmployeeAttendance('gian', true),
    EmployeeAttendance('grunt', false),
    // Add more employee attendance data here
  ];

  List<EmployeeAttendance> _filteredEmployeeAttendanceList = [];

  @override
  void initState() {
    super.initState();
    _startTimer();
    _updateDateTime();
    _filteredEmployeeAttendanceList = _employeeAttendanceList;
  }

  void _filterEmployees(String query) {
    setState(() {
      _filteredEmployeeAttendanceList = _employeeAttendanceList
          .where((employee) =>
              employee.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _startTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = _getCurrentTime();
      });
    });
  }

  void _updateDateTime() {
    final now = DateTime.now();
    final formattedDate = DateFormat.yMMMMd().format(now);
    final formattedDay = DateFormat.EEEE().format(now);
    setState(() {
      _currentDate = formattedDate;
      _currentDay = formattedDay;
    });
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return DateFormat.Hms().format(now);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Card(
            elevation: 8,
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _currentDay,
                    style: GoogleFonts.prompt(
                        color: Colors.green.shade800,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _currentDate,
                        style: GoogleFonts.prompt(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        _currentTime,
                        style: GoogleFonts.prompt(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Card(
            elevation: 8,
            margin: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'School Calendar',
                    style: GoogleFonts.prompt(
                      color: Colors.blue.shade800,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TableCalendar(
                    firstDay: DateTime.utc(2023, 8, 1),
                    lastDay: DateTime.utc(2024, 7, 31),
                    focusedDay: DateTime.now(),
                    selectedDayPredicate: (day) {
                      return isSameDay(day, DateTime.now());
                    },
                  ),
                ],
              ),
            ),
          ),
          Card(
            elevation: 8,
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Employee Attendance',
                    style: GoogleFonts.prompt(
                      color: Colors.red.shade800,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    onChanged: _filterEmployees,
                    decoration: const InputDecoration(
                      hintText: 'Search Employee',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: _filteredEmployeeAttendanceList.length,
                    itemBuilder: (context, index) {
                      final employee = _filteredEmployeeAttendanceList[index];
                      return ListTile(
                        title: Text(employee.name),
                        trailing: Text(
                          employee.isPresent ? 'Present' : 'Absent',
                          style: TextStyle(
                            color:
                                employee.isPresent ? Colors.green : Colors.red,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const Copyright(),
        ],
      ),
    );
  }
}

class EmployeeAttendance {
  final String name;
  final bool isPresent;

  EmployeeAttendance(this.name, this.isPresent);
}
