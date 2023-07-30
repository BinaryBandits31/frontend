import 'package:flutter/material.dart';
import 'package:frontend/services/branch_services.dart';

import '../models/branch.dart';

class BranchProvider extends ChangeNotifier {
  List<Branch> _branches = [];
  List<Branch> _filteredBranches = [];
  bool isLoading = false;
  String? error;

  List<Branch> get branches => _branches;
  List<Branch> get filteredBranches => _filteredBranches;

  DataTableSource? branchesSource;

  Future<void> fetchBranches() async {
    isLoading = true;
    notifyListeners();
    try {
      _branches = await BranchServices.fetchBranches();
      _filteredBranches = _branches;
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

  Future<bool> editBranch(Branch branch) async {
    isLoading = true;
    try {
      return await BranchServices.editBranch(branch);
    } catch (e) {
      print(e.toString());
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void searchBranch(String query) {
    isLoading = true;
    if (query.isNotEmpty) {
      final String lowerCaseQuery = query.toLowerCase();
      List<Branch> filteredBranches = [];
      for (Branch branch in _branches) {
        final String lowerCaseBranchName = branch.name.toLowerCase();

        if (lowerCaseBranchName.contains(lowerCaseQuery)) {
          filteredBranches.add(branch);
        }
      }
      _filteredBranches = filteredBranches;
    } else {
      _filteredBranches = _branches;
    }
    isLoading = false;
    notifyListeners();
  }

  void branchDispose() {
    _branches = [];
    isLoading = false;
    error;
    notifyListeners();
  }
}
