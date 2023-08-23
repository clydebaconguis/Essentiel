import 'package:essentiel/components/dropdown.dart';
import 'package:flutter/material.dart';

class AccountReceivable extends StatefulWidget {
  const AccountReceivable({super.key});

  @override
  State<AccountReceivable> createState() => _AccountReceivableState();
}

class _AccountReceivableState extends State<AccountReceivable> {
  String selectedYear = '2023-2024';
  String selectedSemester = '1st Semester';
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  List<String> schoolYears = ['2023-2024', '2022-2023'];
  List<String> semesters = ['1st Semester', '2nd Semester', 'Summer'];

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isFromDate ? fromDate : toDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != (isFromDate ? fromDate : toDate)) {
      setState(() {
        if (isFromDate) {
          fromDate = picked;
        } else {
          toDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: <Widget>[
            CardWithDropdown(
              icon: Icons.filter_alt_outlined,
              labelText: 'Select School Year:',
              selectedValue: selectedYear,
              items: schoolYears,
              onChanged: (newValue) {
                setState(() {
                  selectedYear = newValue!;
                });
              },
            ),
            const SizedBox(height: 5.0),
            CardWithDropdown(
              icon: Icons.filter_alt_outlined,
              labelText: 'Select Semester:',
              selectedValue: selectedSemester,
              items: semesters,
              onChanged: (newValue) {
                setState(() {
                  selectedSemester = newValue!;
                });
              },
            ),
            const SizedBox(height: 5.0),
            Card(
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Account Receivables',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Date From'),
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: () => _selectDate(context, true),
                                child: Text(
                                  '${fromDate.toLocal()}'.split(' ')[0],
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.blue),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Date To'),
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: () => _selectDate(context, false),
                                child: Text(
                                  '${toDate.toLocal()}'.split(' ')[0],
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.blue),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Perform the "Generate" action here
                      },
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Generate'),
                    ),
                    const SizedBox(height: 10),
                    Table(
                      border: TableBorder.all(),
                      columnWidths: const {
                        0: FlexColumnWidth(2.0),
                        1: FlexColumnWidth(1.0),
                        2: FlexColumnWidth(1.0),
                        3: FlexColumnWidth(1.0),
                        4: FlexColumnWidth(1.0),
                        5: FlexColumnWidth(1.0),
                      },
                      children: const [
                        TableRow(
                          children: [
                            TableCell(
                                child: Center(child: Text('Academic Program'))),
                            TableCell(
                                child: Center(child: Text('Total Assessment'))),
                            TableCell(child: Center(child: Text('Discounts'))),
                            TableCell(
                                child: Center(child: Text('Net Assessed'))),
                            TableCell(
                                child: Center(child: Text('Total Payment'))),
                            TableCell(child: Center(child: Text('Balance'))),
                          ],
                        ),
                        TableRow(
                          children: [
                            TableCell(
                                child: Center(child: Text('Computer Science'))),
                            TableCell(child: Center(child: Text('\$2000.00'))),
                            TableCell(child: Center(child: Text('\$200.00'))),
                            TableCell(child: Center(child: Text('\$1800.00'))),
                            TableCell(child: Center(child: Text('\$1800.00'))),
                            TableCell(child: Center(child: Text('\$0.00'))),
                          ],
                        ),
                        TableRow(
                          children: [
                            TableCell(
                                child: Center(
                                    child: Text('Business Administration'))),
                            TableCell(child: Center(child: Text('\$1800.00'))),
                            TableCell(child: Center(child: Text('\$150.00'))),
                            TableCell(child: Center(child: Text('\$1650.00'))),
                            TableCell(child: Center(child: Text('\$1650.00'))),
                            TableCell(child: Center(child: Text('\$0.00'))),
                          ],
                        ),
                        TableRow(
                          decoration: BoxDecoration(
                            border: Border(top: BorderSide(width: 1.0)),
                          ),
                          children: [
                            TableCell(child: Center(child: Text('Total'))),
                            TableCell(child: Center(child: Text('\$3800.00'))),
                            TableCell(child: Center(child: Text('\$350.00'))),
                            TableCell(child: Center(child: Text('\$3450.00'))),
                            TableCell(child: Center(child: Text('\$3450.00'))),
                            TableCell(child: Center(child: Text('\$0.00'))),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
