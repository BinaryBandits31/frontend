import 'package:flutter/material.dart';
import 'package:frontend/services/auth_services.dart';

import '../models/user.dart';

class UserProvider extends ChangeNotifier {
  User? user;
  bool isLoading = false;
  String? error;

  Future<void> fetchUserData(dynamic data) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      user = await AuthServices.userLogin(data);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  int? getLevel() {
    if (user != null) {
      final userLevel = user!.empLevel;
      int level;
      if (userLevel == 'OWNER') {
        level = 4;
      } else {
        level = userLevel[1] as int;
      }
      return level;
    }
    return null;
  }

  void logOut() {
    user = null;
    notifyListeners();
  }
}
