import 'package:flutter/material.dart';
import 'package:frontend/models/stock_item.dart';
import 'package:frontend/pages/app/dashboard.dart';
import 'package:frontend/services/expiry_alert_services.dart';

class AppProvider extends ChangeNotifier {
  Widget? selectedTab = const Dashboard();
  String? pathTitle = 'Dashboard';
  int _alerts = 0;
  List<StockItem?> _expiringStock = [];

  int get alerts => _alerts;
  List<StockItem?> get expiringStock => _expiringStock;

  void updateSelectedTab(Widget tab) {
    selectedTab = tab;
    notifyListeners();
  }

  void updatedSelectedTitle(String newTitle) {
    pathTitle = newTitle;
    notifyListeners();
  }

  Future<void> checkExpiryAlert() async {
    try {
      List<StockItem?> expiryList = await ExpiryServices.checkExpiry();
      if (expiryList.isNotEmpty) {
        _alerts = expiryList.length;
        _expiringStock = expiryList;
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      notifyListeners();
    }
  }

  void appDispose() {
    selectedTab = const Dashboard();
    pathTitle = 'Dashboard';
    _alerts = 0;
    _expiringStock = [];
    notifyListeners();
  }
}
