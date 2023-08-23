import 'package:essentiel/components/dropdown.dart';
import 'package:flutter/material.dart';

class EnrollmentStat extends StatefulWidget {
  const EnrollmentStat({super.key});

  @override
  State<EnrollmentStat> createState() => _EnrollmentStatState();
}

class _EnrollmentStatState extends State<EnrollmentStat> {
  String selectedYear = '2023-2024';
  String selectedSemester = '1st Semester';

  List<String> schoolYears = ['2023-2024', '2022-2023'];
  List<String> semesters = ['1st Semester', '2nd Semester', 'Summer'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: ListView(
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
            CardRowWithIcons(
              items: [
                CardItem(
                  icon: Icons.star_border_rounded,
                  label: 'Dropped Out',
                  number: '15',
                ),
                CardItem(
                  icon: Icons.star_border_rounded,
                  label: 'Transferred Out',
                  number: '5',
                ),
                CardItem(
                  icon: Icons.star_border_rounded,
                  label: 'Transferred In',
                  number: '5',
                ),
                // Add more CardItems as needed
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CardRowWithIcons extends StatelessWidget {
  final List<CardItem> items;

  const CardRowWithIcons({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16.0,
      runSpacing: 16.0,
      children: items.map((item) {
        return CardItemWidget(item: item);
      }).toList(),
    );
  }
}

class CardItem {
  final IconData icon;
  final String label;
  final String number;

  CardItem({required this.icon, required this.label, required this.number});
}

class CardItemWidget extends StatelessWidget {
  final CardItem item;

  const CardItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                color: Colors.yellow.shade700,
              ),
              width: 50,
              height: 50,
              child: Icon(item.icon),
            ),
            const SizedBox(width: 10.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.label,
                ),
                const SizedBox(height: 4),
                Text(
                  item.number,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
