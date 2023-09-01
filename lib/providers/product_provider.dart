import 'package:flutter/material.dart';
import 'package:frontend/models/branch.dart';
import 'package:frontend/models/stock_item.dart';
import 'package:frontend/services/product_services.dart';
import 'package:frontend/services/stock_services.dart';

import '../models/product.dart';

class ProductProvider extends ChangeNotifier {
  //Products
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  bool isLoading = false;
  String? error;

  List<Product> get products => _products;
  List<Product> get filteredProducts => _filteredProducts;

  //Product Stock
  Branch? _selectedBranch;
  List<StockItem> _productStock = [];
  List<StockItem> _filteredProductStock = [];

  List<StockItem> get productStock => _productStock;
  List<StockItem> get filteredProductStock => _filteredProductStock;

// Products
  Future<void> fetchProducts() async {
    isLoading = true;
    notifyListeners();
    try {
      _products = await ProductServices.fetchProducts();
      _filteredProducts = _products;
    } catch (e) {
      debugPrint(e.toString());
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createProduct(Product product) async {
    isLoading = true;
    notifyListeners();
    try {
      return await ProductServices.createProduct(product);
    } catch (e) {
      debugPrint(e.toString());
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> editProduct(Product product) async {
    isLoading = true;
    notifyListeners();
    try {
      return await ProductServices.editProduct(product);
    } catch (e) {
      debugPrint('error dey here naa');
      debugPrint(e.toString());
      error = e.toString();
      notifyListeners();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void searchProduct(String query) {
    isLoading = true;
    if (query.isNotEmpty) {
      final String lowerCaseQuery = query.toLowerCase();
      List<Product> filteredProducts = [];
      for (Product branch in _products) {
        final String lowerCaseProductName = branch.name.toLowerCase();

        if (lowerCaseProductName.contains(lowerCaseQuery)) {
          filteredProducts.add(branch);
        }
      }
      _filteredProducts = filteredProducts;
    } else {
      _filteredProducts = _products;
    }
    isLoading = false;
    notifyListeners();
  }

// Stock
  Future<void> fetchProductStock() async {
    isLoading = true;
    notifyListeners();
    try {
      _productStock = await StockServices.getStockItems([],
          branchID: _selectedBranch!.branchID);
      _filteredProductStock = _productStock;
    } catch (e) {
      debugPrint(e.toString());
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void searchProductStock(String query) {
    isLoading = true;
    if (query.isNotEmpty) {
      final String lowerCaseQuery = query.toLowerCase();
      List<StockItem> filteredProductStock = [];
      for (StockItem stockItem in _productStock) {
        final String lowerCaseStockItemName =
            stockItem.productName.toLowerCase();

        if (lowerCaseStockItemName.contains(lowerCaseQuery)) {
          filteredProductStock.add(stockItem);
        }
      }
      _filteredProductStock = filteredProductStock;
    } else {
      _filteredProductStock = _productStock;
    }
    isLoading = false;
    notifyListeners();
  }

  void setSelectedBranch(Branch branch) async {
    if (_selectedBranch != branch) {
      _selectedBranch = branch;
      await fetchProductStock();
      notifyListeners();
    }
  }

  void productDispose() {
    _products = [];
    _filteredProducts = [];
    _productStock = [];
    _filteredProductStock = [];
    isLoading = false;
    error = null;
    notifyListeners();
  }
}
