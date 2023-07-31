import 'package:frontend/services/stock_services.dart';
import '../models/stock_item.dart';

import 'package:flutter/material.dart';

class StockProvider extends ChangeNotifier{
  List<StockItem> _stockItems = [];
  List<StockItem> _filteredStockItems = [];
  bool isLoading = false;
  String? error;

  List<StockItem> get stockItems => _stockItems;
  List<StockItem> get filteredStockItems => _filteredStockItems;

  Future<void> fetchStockItems() async {
    isLoading = true;
    notifyListeners();
    try {
      _stockItems = await StockServices.getStockItems();
      _filteredStockItems = _stockItems;
    } catch (e) {
      debugPrint(e.toString());
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void searchStockItem(String query) {
   //todo
  }
}