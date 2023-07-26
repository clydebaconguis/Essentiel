import 'package:flutter/material.dart';

class NavigationProvider extends ChangeNotifier {
  String _activeNav = '';
  bool _isCollapsed = false;

  bool get isCollapsed => _isCollapsed;
  String get activeNav => _activeNav.isNotEmpty ? _activeNav : 'Home';

  void setActiveNav(data) {
    _activeNav = data;

    notifyListeners();
  }

  void toggleIsCollapsed() {
    _isCollapsed = !isCollapsed;

    notifyListeners();
  }
}
