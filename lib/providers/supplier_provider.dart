import 'package:flutter/material.dart';
import 'package:frontend/models/supplier.dart';
import 'package:frontend/services/supplier_services.dart';

class SupplierProvider extends ChangeNotifier {
  List<Supplier> _suppliers = [];
  List<Supplier> _filteredSuppliers = [];
  bool isLoading = false;
  String? error;

  List<Supplier> get suppliers => _suppliers;
  List<Supplier> get filteredSuppliers => _filteredSuppliers;

  DataTableSource? supplierSource;

  Future<void> fetchSuppliers() async {
    isLoading = true;
    notifyListeners();
    try {
      _suppliers = await SupplierServices.fetchSuppliers();
      _filteredSuppliers = _suppliers;
    } catch (e) {
      print(e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createSupplier(dynamic data) async {
    isLoading = true;
    notifyListeners();
    try {
      return await SupplierServices.createSupplier(data);
    } catch (e) {
      print(e.toString());
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void searchSupplier(String query) {
    isLoading = true;
    if (query.isNotEmpty) {
      final String lowerCaseQuery = query.toLowerCase();
      List<Supplier> filteredSuppliers = [];
      for (Supplier supplier in _suppliers) {
        final String lowerCaseSupplierName = supplier.name.toLowerCase();

        if (lowerCaseSupplierName.contains(lowerCaseQuery)) {
          filteredSuppliers.add(supplier);
        }
      }
      _filteredSuppliers = filteredSuppliers;
    } else {
      _filteredSuppliers = _suppliers;
    }
    isLoading = false;
    notifyListeners();
  }

  // Future<bool> editBranch(dynamic data) async {
  //   isLoading = true;
  //   notifyListeners();
  //   try {
  //     return await SupplierServices.editSupplier(data);
  //   } catch (e) {
  //     print(e.toString());
  //     error = e.toString();
  //     return false;
  //   } finally {
  //     isLoading = false;
  //     notifyListeners();
  //   }
  // }

  void supplierDispose() {
    _suppliers = [];
    isLoading = false;
    error;
    notifyListeners();
  }
}
