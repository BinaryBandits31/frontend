import 'package:flutter/material.dart';
import 'package:frontend/models/branch.dart';
import 'package:frontend/models/stock_item.dart';
import 'package:frontend/services/stock_services.dart';

class StockTransferProvider extends ChangeNotifier {
  Branch? _currentBranch;
  Branch? get currentBranch => _currentBranch;

  Branch? _toBranch;
  Branch? get toBranch => _toBranch;

  List<dynamic> _stockItems = [];
  List<dynamic> get stockItems => _stockItems;
  List<StockItem> _allStockItems = [];
  List<StockItem> _products = [];
  List<StockItem> get products => _products;

  void addSelectedProduct(dynamic product) {
    _stockItems.add(product);
    notifyListeners();
  }

  void removeIndexedProduct(int index) {
    _stockItems.removeAt(index);
    notifyListeners();
  }

  void setCurrentBranch(Branch branch) {
    if (_currentBranch != branch) {
      _stockItems = [];
      _products =
          _allStockItems.where((e) => e.branchID == branch.branchID).toList();
      _currentBranch = branch;
      notifyListeners();
    }
  }

  void setToBranch(Branch branch) {
    _toBranch = branch;
    notifyListeners();
  }

  Future<void> fetchStockItems() async {
    try {
      final List<StockItem> items = await StockServices.getStockItems();
      if (items.isNotEmpty) {
        _allStockItems = items;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<bool> initiateTransfer() async {
    bool res = false;

    dynamic stockData = {
      'sendingBranch': _currentBranch!.branchID,
      'stockItems': convertListToMap(_stockItems),
      'receivingBranch': _toBranch!.branchID,
    };
    try {
      bool response = await StockServices.transferStock(stockData);
      if (response) {
        res = true;
        _stockItems = [];
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

  Map<dynamic, dynamic> convertListToMap(List<dynamic> inputList) {
    Map<dynamic, dynamic> resultMap = {};
    for (var item in inputList) {
      if (item is Map &&
          item.containsKey("product_Id") &&
          item.containsKey("quantity")) {
        resultMap[item["product_Id"]] = int.parse(item["quantity"]);
      }
    }
    return resultMap;
  }

  void disposeST() {
    _currentBranch = null;
    _toBranch = null;
    _stockItems = [];
    _products = [];
    _allStockItems = [];
    notifyListeners();
  }
}
