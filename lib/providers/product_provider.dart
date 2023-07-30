import 'package:flutter/material.dart';
import 'package:frontend/services/product_services.dart';

import '../models/product.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  bool isLoading = false;
  String? error;

  List<Product> get products => _products;
  List<Product> get filteredProducts => _filteredProducts;

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
      debugPrint(e.toString());
      error = e.toString();
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

  Future<bool> deleteProduct(String productId) async {
    isLoading = true;
    notifyListeners();
    try {
      return await ProductServices.deleteProduct(productId);
    } catch (e) {
      debugPrint(e.toString());
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void productDispose() {
    _products = [];
    isLoading = false;
    error = null;
    notifyListeners();
  }
}
