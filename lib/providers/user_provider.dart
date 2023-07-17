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

  void logOut() {
    user = null;
    notifyListeners();
  }
}
