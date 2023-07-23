import 'package:flutter/material.dart';
import 'package:frontend/services/branch_services.dart';

import '../models/branch.dart';

class BranchProvider extends ChangeNotifier {
  List<Branch> _branches = [];
  bool isLoading = false;
  String? error;

  List<Branch> get branches => _branches;

  DataTableSource? branchesSource;

  Future<void> fetchBranches() async {
    isLoading = true;
    notifyListeners();
    try {
      _branches = await BranchServices.fetchBranches();
    } catch (e) {
      print(e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createBranch(dynamic data) async {
    isLoading = true;
    notifyListeners();
    try {
      return await BranchServices.createBrach(data);
    } catch (e) {
      print(e.toString());
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> editBranch(dynamic data) async {
    isLoading = true;
    notifyListeners();
    try {
      return await BranchServices.editBranch(data);
    } catch (e) {
      print(e.toString());
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void branchDispose() {
    _branches = [];
    isLoading = false;
    error;
    notifyListeners();
  }
}
