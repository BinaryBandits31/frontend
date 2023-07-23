import 'package:flutter/material.dart';
import 'package:frontend/pages/app/dashboard.dart';

class AppProvider extends ChangeNotifier {
  Widget? selectedTab = const Dashboard();
  String? pathTitle = 'Dashboard';

  void updateSelectedTab(Widget tab) {
    selectedTab = tab;
    notifyListeners();
  }

  void updatedSelectedTitle(String newTitle) {
    pathTitle = newTitle;
    notifyListeners();
  }

  void logOut() {
    selectedTab = const Dashboard();
    pathTitle = 'Dashboard';
    notifyListeners();
  }
}
