import 'package:flutter/material.dart';

class NavigationProvider extends ChangeNotifier {
  String _activeNav = '';
  bool _isCollapsed = false;
  bool _isExpanded = false;
  bool get isCollapsed => _isCollapsed;
  bool get isExpanded => _isExpanded;
  String get activeNav => _activeNav.isNotEmpty ? _activeNav : 'Dashboard';
  String get activeNav2 => _activeNav.isNotEmpty ? _activeNav : 'Home';

  void setActiveNav(data) {
    _activeNav = data;

    notifyListeners();
  }

  void toggleIsCollapsed() {
    _isCollapsed = !isCollapsed;

    notifyListeners();
  }

  void toggleExpanded() {
    _isExpanded = !isExpanded;

    notifyListeners();
  }
}
