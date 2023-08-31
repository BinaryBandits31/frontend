import 'dart:convert';
import 'package:frontend/providers/stock_transfer_provider.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/utils/constants.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/stock_item.dart';

class StockServices {
  static String endpoint = '/org/stock';

  static Future<List<StockItem>> getStockBatches() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('userToken')!;

      final response = await http
          .get(Uri.parse('$port$endpoint'), headers: {'token': token});

      if (response.statusCode == 200) {
        return (jsonDecode(response.body) as List<dynamic>)
            .map((json) => StockItem.fromJson(json))
            .toList();
      } else {
        throw Exception(jsonDecode(response.body)['error']);
      }
    } catch (e) {
      await isTokenExpired(e);
      throw Exception(e);
    }
  }

  static Future<List<StockItem>> getStockItems(List<String> stockItemIDs,
      {String? branchID}) async {
    String endpoint = '/org/stock/item';
    try {
      final userProvider =
          Provider.of<UserProvider>(Get.context!, listen: false);

      final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('userToken')!;

      final response = await http.post(Uri.parse('$port$endpoint'),
          headers: {'token': token},
          body: jsonEncode({'stockItems': stockItemIDs}));

      if (response.statusCode == 200) {
        branchID ??= userProvider.user!.branchId;
        final res = (jsonDecode(response.body)[branchID] as List<dynamic>)
            .map((json) => StockItem.fromJson(json))
            .toList();
        return res;
      } else {
        throw Exception(jsonDecode(response.body)['error']);
      }
    } catch (e) {
      await isTokenExpired(e);
    }
    return [];
  }

  static Future<dynamic> getAllStockItems() async {
    //returns all stocks as dynamic >> must select branch
    //using branchID as key to get list of StockItems
    String endpoint = '/org/stock/item';
    try {
      final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('userToken')!;

      final response = await http.post(Uri.parse('$port$endpoint'),
          headers: {'token': token}, body: jsonEncode({'stockItems': []}));

      if (response.statusCode == 200) {
        final res = (jsonDecode(response.body));
        return res;
      } else {
        throw Exception(jsonDecode(response.body)['error']);
      }
    } catch (e) {
      await isTokenExpired(e);
    }
    return [];
  }

  static Future<bool> purchaseStock(dynamic data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('userToken')!;

      final response = await http.post(Uri.parse('$port/org/stock'),
          headers: {'token': token}, body: jsonEncode(data));

      if (response.statusCode == 201) {
        return true;
      }
    } catch (e) {
      await isTokenExpired(e);
      throw Exception(e);
    }
    return false;
  }

  static Future<bool> transferStock(dynamic data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('userToken')!;

      final response = await http.post(Uri.parse('$port/org/stock/transfer'),
          headers: {'token': token}, body: jsonEncode(data));
      if (response.statusCode == 201) {
        return true;
      }
    } catch (e) {
      await isTokenExpired(e);
      throw Exception(e);
    }
    return false;
  }

  static Future<List<dynamic>> getStockTransferBatches() async {
    String endpoint = '/org/stock/transfer';
    try {
      final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('userToken')!;

      final userProvider =
          Provider.of<UserProvider>(Get.context!, listen: false);
      final userLevel = userProvider.getLevel();

      final response = await http
          .get(Uri.parse('$port$endpoint'), headers: {'token': token});

      if (response.statusCode == 200) {
        dynamic res = [];
        if (userLevel! >= 3) {
          res = (jsonDecode(response.body) as List<dynamic>);
          return res;
        } else {
          if (jsonDecode(response.body)['incoming'] == null) return res;
          res = (jsonDecode(response.body)['incoming'] as List<dynamic>);
          return res
              .where((e) =>
                  e['receivingBranch'] == userProvider.user!.branchId &&
                  e['state'] == "IN PROGRESS")
              .toList();
        }
      } else {
        throw Exception(jsonDecode(response.body)['error']);
      }
    } catch (e) {
      await isTokenExpired(e);
      throw Exception(e);
    }
  }

  static Future<bool> confirmTransfer(String currentBatchID) async {
    String endpoint = '/org/stock/transfer/$currentBatchID/received';
    try {
      final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('userToken')!;

      final response = await http
          .put(Uri.parse('$port$endpoint'), headers: {'token': token});

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      await isTokenExpired(e);
      Provider.of<StockTransferProvider>(Get.context!, listen: false)
          .setTransferError(e.toString());
      throw Exception(e);
    }
  }

  static Future<bool> terminateTransfer(String currentBatchID) async {
    String endpoint = '/org/stock/transfer/$currentBatchID/terminate';
    try {
      final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('userToken')!;

      final response = await http
          .put(Uri.parse('$port$endpoint'), headers: {'token': token});

      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      await isTokenExpired(e);
      Provider.of<StockTransferProvider>(Get.context!, listen: false)
          .setTransferError(e.toString());
      throw Exception(e);
    }
  }

  static Future<bool> confirmSale(saleData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('userToken')!;
      final response = await http.post(Uri.parse('$port/org/sale'),
          headers: {'token': token}, body: jsonEncode(saleData));
      if (response.statusCode == 201) {
        return true;
      }
    } catch (e) {
      await isTokenExpired(e);
      throw Exception(e);
    }
    return false;
  }
}
