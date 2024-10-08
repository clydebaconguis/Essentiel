import 'package:essentiel/models/drawer_item.dart';
import 'package:flutter/material.dart';

final itemsFirst = [
  DrawerItem(
      title: 'Dashboard',
      icon: Icons.dashboard_customize_outlined,
      isEnabled: false),
  DrawerItem(
      title: 'Attendance', icon: Icons.fact_check_outlined, isEnabled: false),
  DrawerItem(
      title: 'Report Card',
      icon: Icons.library_books_outlined,
      isEnabled: false),
  DrawerItem(
      title: 'Class Schedule', icon: Icons.schedule_outlined, isEnabled: false),
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

final dioceseItems = [
  DrawerItem(
      title: 'School List',
      icon: Icons.dashboard_customize_rounded,
      isEnabled: false),
  DrawerItem(title: 'Home', icon: Icons.home_rounded, isEnabled: false),
];

final finance = [
  DrawerItem(
      title: 'Cashier Transactions',
      icon: Icons.circle_outlined,
      isEnabled: false),
  DrawerItem(
      title: 'Acccount Receivable',
      icon: Icons.circle_outlined,
      isEnabled: false),
];
final hresource = [
  DrawerItem(
      title: 'Employee Profile', icon: Icons.circle_outlined, isEnabled: false),
];

final enrollmentStat = [
  DrawerItem(
      title: 'Enrollment Statistics',
      icon: Icons.bar_chart_rounded,
      isEnabled: false),
];
