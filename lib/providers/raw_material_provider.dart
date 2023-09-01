import 'package:flutter/material.dart';
import 'package:frontend/models/branch.dart';
import 'package:frontend/models/raw_material.dart';
import 'package:frontend/services/raw_material_services.dart';

class RawMaterialProvider extends ChangeNotifier {
  List<RawMaterial> _rawMaterials = [];
  List<RawMaterial> _filteredRawMaterials = [];
  Branch? _selectedBranch;
  bool isLoading = false;
  String? error;

  List<RawMaterial> get rawMaterials => _rawMaterials;
  List<RawMaterial> get filteredRawMaterials => _filteredRawMaterials;
  Branch? get selectedBranch => _selectedBranch;

  Future<void> fetchRawMaterials() async {
    isLoading = true;
    notifyListeners();
    try {
      _rawMaterials = await RawMaterialServices.fetchRawMaterials();
      _filteredRawMaterials = _rawMaterials;
    } catch (e) {
      debugPrint(e.toString());
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void setBranch(Branch branch) {
    if (_selectedBranch != branch) {
      _selectedBranch = branch;
      notifyListeners();
    }
  }

  void searchRawMaterial(String query) {
    isLoading = true;
    if (query.isNotEmpty) {
      final String lowerCaseQuery = query.toLowerCase();
      List<RawMaterial> filteredRawMaterials = [];
      for (RawMaterial rm in _rawMaterials) {
        final String lowerCaseRMName = rm.name.toLowerCase();

        if (lowerCaseRMName.contains(lowerCaseQuery)) {
          filteredRawMaterials.add(rm);
        }
      }
      _filteredRawMaterials = filteredRawMaterials;
    } else {
      _filteredRawMaterials = _rawMaterials;
    }
    isLoading = false;
    notifyListeners();
  }

  void disposeRM() {
    _rawMaterials = [];
    _filteredRawMaterials = [];
    isLoading = false;
    _selectedBranch = null;
    error = null;
    notifyListeners();
  }

  Future<bool> createRawMaterial(RawMaterial rawMaterial) async {
    bool response = false;
    try {
      final res = await RawMaterialServices.createNewUser(rawMaterial);
      if (res) {
        response = true;
      }
    } catch (e) {
      print(e.toString());
      error = e.toString();
    } finally {
      notifyListeners();
    }
    return response;
  }

  Future<bool> addRawMaterialStock(dynamic rawMaterialData) async {
    isLoading = true;
    notifyListeners();
    try {
      return await RawMaterialServices.addRawMaterialStock(rawMaterialData);
    } catch (e) {
      debugPrint(e.toString());
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
