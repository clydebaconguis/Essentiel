import 'package:flutter/material.dart';

class CardWithDropdown extends StatelessWidget {
  final IconData icon;
  final String labelText;
  final String selectedValue;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const CardWithDropdown({
    super.key,
    required this.icon,
    required this.labelText,
    required this.selectedValue,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 10),
            Text(
              labelText,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const Spacer(),
            DropdownButton<String>(
              value: selectedValue,
              onChanged: onChanged,
              items: items.map<DropdownMenuItem<String>>((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
