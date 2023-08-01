import 'package:flutter/material.dart';
import 'package:frontend/models/branch.dart';
import 'package:frontend/models/supplier.dart';
import 'package:frontend/services/stock_services.dart';

class StockPurchaseProvider extends ChangeNotifier {
  Branch? _currentBranch;
  Branch? get currentBranch => _currentBranch;

  Supplier? _supplier;
  Supplier? get supplier => _supplier;

  List<dynamic> _stockItems = [];
  List<dynamic> get stockItems => _stockItems;

  void addSelectedProduct(dynamic product) {
    _stockItems.add(product);
    debugPrint('added to stockItems');
    notifyListeners();
  }

  void removeIndexedProduct(int index) {
    _stockItems.removeAt(index);
    notifyListeners();
  }

  void setBranch(Branch branch) {
    _currentBranch = branch;
  }

  void setSupplier(Supplier supplier) {
    _supplier = supplier;
  }

  Future<bool> confirmPurchase() async {
    bool res = false;
    dynamic stockData = {
      'supplier_Id': _supplier!.id,
      'stockItems': _stockItems,
      'branch_Id': _currentBranch!.branchID,
    };
    try {
      bool response = await StockServices.purchaseStock(stockData);
      if (response) {
        res = true;
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      notifyListeners();
    }
    return res;
  }

  void cancelPurchase() {
    _stockItems = [];
    notifyListeners();
  }
}
