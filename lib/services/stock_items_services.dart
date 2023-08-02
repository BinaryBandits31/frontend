import 'dart:convert';
import 'package:flutter/material.dart';
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
      throw Exception(e);
    }
  }

  static Future<List<StockItem>> getStockItems(
      {List stockItemIDs = const []}) async {
    String endpoint = '/org/stock/item';
    try {
      final userProvider =
          Provider.of<UserProvider>(Get.context!, listen: false);
      final userLevel = userProvider.getLevel();

      final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('userToken')!;

      final response = await http.post(Uri.parse('$port$endpoint'),
          headers: {'token': token},
          body: jsonEncode({'stockItems': stockItemIDs}));

      if (response.statusCode == 200) {
        final res = (jsonDecode(response.body) as List<dynamic>)
            .map((json) => StockItem.fromJson(json))
            .toList();
        if (userLevel! >= 3) {
          return res;
        } else {
          return res
              .where((item) => item.branchID == userProvider.user!.branchId)
              .toList();
        }
      } else {
        throw Exception(jsonDecode(response.body)['error']);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

//TODO: Not working
  static Future<bool> purchaseStock(dynamic data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('userToken')!;

      final response = await http.post(Uri.parse('$port/org/stock'), headers: {
        'token': token
      }, body: <String, dynamic>{
        'supplier_Id': data['supplier_Id'],
        'stockItems': data['stockItems'] as List<dynamic>,
        'branch_Id': data['branch_Id'],
      });

      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 201) {
        return true;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  static transferStock(dynamic data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('userToken')!;

      final response = await http.post(Uri.parse('$port$endpoint'),
          headers: {'token': token}, body: jsonEncode(data));

      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 201) {
        return true;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }
}
