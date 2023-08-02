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

  List<dynamic> _transferBatches = [];
  List<dynamic> get transferBatches => _transferBatches;
  dynamic _currentBatch;
  dynamic get currentBatch => _currentBatch;
  List<dynamic> _incomingStockItems = [];
  List<dynamic> get incomingStockItems => _incomingStockItems;
  bool isLoadingTransferDetails = false;
  bool isLoadingTransferBatches = false;

  void addSelectedProduct(dynamic product) {
    _stockItems.add(product);
    notifyListeners();
  }

  void removeIndexedProduct(int index) {
    _stockItems.removeAt(index);
    notifyListeners();
  }

  void popTransfer(int index) {
    _transferBatches.removeAt(index);
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

  Future<void> fetchStockItems(List<String> itemIDs) async {
    try {
      final List<StockItem> items = await StockServices.getStockItems(itemIDs);
      if (items.isNotEmpty) {
        _allStockItems = items;
        _incomingStockItems = items
            .map((e) => {
                  'name': e.productName,
                  'quantity': e.quantity,
                })
            .toList();
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchStockTransferBatches() async {
    isLoadingTransferBatches = true;
    notifyListeners();
    try {
      List<dynamic> batches = await StockServices.getStockTransferBatches();
      if (batches.isNotEmpty) {
        _transferBatches = batches;
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoadingTransferBatches = false;
      notifyListeners();
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

  Future<bool> confirmTransfer() async {
    bool res = false;
    try {
      bool response = await StockServices.confirmTransfer(_currentBatch['Id']);
      if (response) {
        res = true;
        _transferBatches.remove(_currentBatch);
        _currentBatch = null;
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

  void getBatchDetails(dynamic batch) async {
    isLoadingTransferDetails = true;
    notifyListeners();
    try {
      _currentBatch = batch;
      List<String> stockItemKeys =
          batch['stockItems'].keys.cast<String>().toList();
      final items = await StockServices.getStockItems(stockItemKeys);
      if (items.isNotEmpty) {
        _incomingStockItems = items;
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoadingTransferDetails = false;
      notifyListeners();
    }
  }

  void disposeST() {
    _currentBranch = null;
    _toBranch = null;
    _stockItems = [];
    _products = [];
    _allStockItems = [];
    _transferBatches = [];
    _currentBatch = null;
    _incomingStockItems = [];
    notifyListeners();
  }

  Future<bool> terminateTransfer() async {
    bool res = false;
    try {
      bool response =
          await StockServices.terminateTransfer(_currentBatch['Id']);
      if (response) {
        res = true;
        _transferBatches.remove(_currentBatch);
        _currentBatch = null;
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      notifyListeners();
    }
    return res;
  }
}
