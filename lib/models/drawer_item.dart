import 'package:flutter/material.dart';

class DrawerItem {
  final String title;
  final IconData icon;
  late bool isEnabled = false;

  DrawerItem(
      {required this.title, required this.icon, required this.isEnabled});
}
