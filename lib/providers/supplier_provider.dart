import 'package:flutter/material.dart';
import 'package:frontend/models/supplier.dart';
import 'package:frontend/services/supplier_services.dart';

class SupplierProvider extends ChangeNotifier {
  List<Supplier> _suppliers = [];
  bool isLoading = false;
  String? error;

  List<Supplier> get suppliers => _suppliers;

  DataTableSource? supplierSource;

  Future<void> fetchSuppliers() async {
    isLoading = true;
    notifyListeners();
    try {
      _suppliers = await SupplierServices.fetchSuppliers();
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
