import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class EmployeeProfile extends StatefulWidget {
  const EmployeeProfile({super.key});

  @override
  State<EmployeeProfile> createState() => _EmployeeProfileState();
}

class _EmployeeProfileState extends State<EmployeeProfile> {
  final List<Teacher> teachers = [
    Teacher(
        name: 'John Doe',
        mainPortal: 'Portal A',
        dateHired: '2022-01-15',
        workedFor: '1 year'),
    Teacher(
        name: 'Jane Smith',
        mainPortal: 'Portal B',
        dateHired: '2021-03-20',
        workedFor: '2 years'),
    // Add more sample data here
  ];

  late _TeacherDataSource _teacherDataSource;

  @override
  void initState() {
    super.initState();
    _teacherDataSource = _TeacherDataSource(teachers);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const SizedBox(
            height: 10.0,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            constraints: const BoxConstraints(maxHeight: 250),
            child: const GenderPieChart(
              malePercentage:
                  40, // Example values, replace with actual percentages
              femalePercentage: 50,
              unspecifiedPercentage: 10,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: PaginatedDataTable(
              header: _SearchBar(dataSource: _teacherDataSource),
              source: _teacherDataSource,
              columns: const [
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Main Portal')),
                DataColumn(label: Text('Date Hired')),
                DataColumn(label: Text('Worked For')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatefulWidget {
  final _TeacherDataSource dataSource;

  const _SearchBar({required this.dataSource});

  @override
  State<_SearchBar> createState() => __SearchBarState();
}

class __SearchBarState extends State<_SearchBar> {
  final TextEditingController _filterController = TextEditingController();

  @override
  void dispose() {
    _filterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _filterController,
        onChanged: (value) {
          widget.dataSource.applyFilter(value);
        },
        decoration: const InputDecoration(
          hintText: 'Search by name...',
          prefixIcon: Icon(Icons.search),
        ),
      ),
    );
  }
}

class GenderPieChart extends StatelessWidget {
  final double malePercentage;
  final double femalePercentage;
  final double unspecifiedPercentage;

  const GenderPieChart({
    super.key,
    required this.malePercentage,
    required this.femalePercentage,
    required this.unspecifiedPercentage,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: AspectRatio(
        aspectRatio: 1,
        child: PieChart(
          PieChartData(
            sections: [
              PieChartSectionData(
                value: malePercentage,
                title: 'Male',
                color: Colors.blue,
              ),
              PieChartSectionData(
                value: femalePercentage,
                title: 'Female',
                color: Colors.pink,
              ),
              PieChartSectionData(
                value: unspecifiedPercentage,
                title: 'Unspecified',
                color: Colors.grey,
              ),
            ],
            sectionsSpace: 4,
            centerSpaceRadius: 40,
            startDegreeOffset: -90,
          ),
        ),
      ),
    );
  }
}

class Teacher {
  final String name;
  final String mainPortal;
  final String dateHired;
  final String workedFor;

  Teacher({
    required this.name,
    required this.mainPortal,
    required this.dateHired,
    required this.workedFor,
  });
}

class _TeacherDataSource extends DataTableSource {
  final List<Teacher> _teachers;
  final List<Teacher> _filteredTeachers = List<Teacher>.empty(growable: true);
  bool _isFiltering = false;

  _TeacherDataSource(this._teachers);

  void applyFilter(String filter) {
    _isFiltering = filter.isNotEmpty;

    _filteredTeachers.clear();
    if (_isFiltering) {
      _filteredTeachers.addAll(_teachers.where(
        (teacher) => teacher.name.toLowerCase().contains(filter.toLowerCase()),
      ));
    }
    notifyListeners();
  }

  @override
  DataRow? getRow(int index) {
    final teacher = _isFiltering ? _filteredTeachers[index] : _teachers[index];

    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(teacher.name)),
        DataCell(Text(teacher.mainPortal)),
        DataCell(Text(teacher.dateHired)),
        DataCell(Text(teacher.workedFor)),
      ],
    );
  }

  @override
  int get rowCount =>
      _isFiltering ? _filteredTeachers.length : _teachers.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;

  // void applyFilter(String filter) {
  //   _filteredTeachers.clear();
  //   if (filter.isEmpty) {
  //     _filteredTeachers.addAll(_teachers);
  //   } else {
  //     _filteredTeachers.addAll(_teachers.where((teacher) =>
  //         teacher.name.toLowerCase().contains(filter.toLowerCase())));
  //   }
  //   notifyListeners();
  // }
}
