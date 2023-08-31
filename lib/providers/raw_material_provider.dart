import 'package:flutter/material.dart';
import 'package:frontend/models/raw_material.dart';
import 'package:frontend/services/raw_material_services.dart';

class RawMaterialProvider extends ChangeNotifier {
  List<RawMaterial> _rawMaterials = [];
  List<RawMaterial> _filteredRawMaterials = [];
  bool isLoading = false;
  String? error;

  List<RawMaterial> get rawMaterials => _rawMaterials;
  List<RawMaterial> get filteredRawMaterials => _filteredRawMaterials;

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

  // Future<bool> createProduct(Product product) async {
  //   isLoading = true;
  //   notifyListeners();
  //   try {
  //     return await ProductServices.createProduct(product);
  //   } catch (e) {
  //     debugPrint(e.toString());
  //     error = e.toString();
  //     return false;
  //   } finally {
  //     isLoading = false;
  //     notifyListeners();
  //   }
  // }

  // Future<bool> editProduct(Product product) async {
  //   isLoading = true;
  //   notifyListeners();
  //   try {
  //     return await ProductServices.editProduct(product);
  //   } catch (e) {
  //     debugPrint(e.toString());
  //     error = e.toString();
  //     return false;
  //   } finally {
  //     isLoading = false;
  //     notifyListeners();
  //   }
  // }

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
}
