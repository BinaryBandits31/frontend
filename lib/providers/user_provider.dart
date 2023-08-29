import 'package:flutter/material.dart';
import 'package:frontend/services/auth_services.dart';

import '../models/user.dart';

class UserProvider extends ChangeNotifier {
  User? user;
  bool isLoading = false;
  String? error;
  String? _createUserError;
  String? get createUserError => _createUserError;
  List<User> _fellowUsers = [];
  List<User> _filteredFellowUsers = [];
  List<User> get filteredFellowUsers => _filteredFellowUsers;
  List<User> get fellowUsers => _fellowUsers;
  bool isLoadingFellowUsers = false;

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

  void setCreateUserError(String err) {
    _createUserError = err;
    notifyListeners();
  }

  Future<void> fetchFellowUsers() async {
    isLoadingFellowUsers = true;
    try {
      List<User>? users = await AuthServices.fetchFellowUsers();
      if (users != null) {
        _fellowUsers = users;
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoadingFellowUsers = false;
      notifyListeners();
    }
  }

  Future<bool> validateToken(String token) async {
    bool res = false;
    try {
      user = await AuthServices.validateUserToken(token);
      if (user != null) {
        res = true;
        notifyListeners();
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return res;
  }

  void searchFellowUsers(String query) {
    isLoadingFellowUsers = true;
    if (query.isNotEmpty) {
      final String lowerCaseQuery = query.toLowerCase();
      List<User> filteredFellowUsers = [];
      for (User user in _fellowUsers) {
        final String lowerCaseUserName = user.username.toLowerCase();

        if (lowerCaseUserName.contains(lowerCaseQuery)) {
          filteredFellowUsers.add(user);
        }
      }
      _filteredFellowUsers = filteredFellowUsers;
    } else {
      _filteredFellowUsers = _fellowUsers;
    }
    isLoadingFellowUsers = false;
    notifyListeners();
  }

  int? getLevel() {
    if (user != null) {
      final userLevel = user!.empLevel;
      int level;
      if (userLevel == 'OWNER') {
        level = 4;
      } else {
        level = int.parse(userLevel![1]);
      }
      return level;
    }
    return null;
  }

  Future<bool> createNewUser(dynamic data) async {
    bool response = false;
    try {
      final res = await AuthServices.createNewUser(data);
      if (res) {
        response = true;
      }
    } catch (e) {
      print(e.toString());
    } finally {
      notifyListeners();
    }
    return response;
  }

  void userDispose() {
    user = null;
    error = null;
    _createUserError = null;
    notifyListeners();
  }
}
