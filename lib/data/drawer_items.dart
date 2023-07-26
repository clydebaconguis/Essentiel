import 'package:essentiel/models/drawer_item.dart';
import 'package:flutter/material.dart';

final itemsFirst = [
  DrawerItem(title: 'Home', icon: Icons.home_rounded, isEnabled: false),
  DrawerItem(
      title: 'Attendance', icon: Icons.fact_check_outlined, isEnabled: false),
  DrawerItem(
      title: 'Report Card',
      icon: Icons.library_books_outlined,
      isEnabled: false),
  DrawerItem(
      title: 'Class Schedule', icon: Icons.class_outlined, isEnabled: false),
];
final itemFirstContinuation = [
  DrawerItem(
      title: 'Billing Information',
      icon: Icons.receipt_long_outlined,
      isEnabled: false),
  DrawerItem(
      title: 'School Calendar',
      icon: Icons.calendar_month_rounded,
      isEnabled: false),
  DrawerItem(
      title: 'Enrollment Information',
      icon: Icons.folder_shared_outlined,
      isEnabled: false),
  DrawerItem(
      title: 'Student Profile',
      icon: Icons.account_circle_outlined,
      isEnabled: false),
];

final itemsFirst2 = [
  DrawerItem(title: 'Logout', icon: Icons.logout_outlined, isEnabled: false),
];
