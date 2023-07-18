import 'package:flutter/material.dart';
import 'package:frontend/pages/app/dashboard.dart';

class AppProvider extends ChangeNotifier {
  Widget? selectedTab = const Dashboard();
  String? title = 'Dashboard';

  void updateSelectedTab(Widget tab) {
    selectedTab = tab;
    notifyListeners();
  }

  void updatedSelectedTitle(String newTitle) {
    title = newTitle;
    notifyListeners();
  }

  void logOut() {
    selectedTab = const Dashboard();
    title = 'Dashboard';
    notifyListeners();
  }
}
