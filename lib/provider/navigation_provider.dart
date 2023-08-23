import 'package:flutter/material.dart';

class NavigationProvider extends ChangeNotifier {
  String _activeNav = '';
  bool _isCollapsed = false;
  bool _isExpanded = false;
  bool _isExpanded2 = false;
  bool _isExpanded3 = false;
  bool get isCollapsed => _isCollapsed;
  bool get isExpanded => _isExpanded;
  bool get isExpanded2 => _isExpanded2;
  bool get isExpanded3 => _isExpanded3;
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

  void toggleExpanded2() {
    _isExpanded2 = !isExpanded2;

    notifyListeners();
  }

  void toggleExpanded3() {
    _isExpanded3 = !isExpanded3;

    notifyListeners();
  }
}
