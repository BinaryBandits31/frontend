import 'dart:convert';

import 'package:frontend/models/stock_item.dart';
import 'package:frontend/utils/constants.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

class ExpiryServices {
  static String endpoint = '/org/expiry';

  static Future<List<StockItem?>> checkExpiry() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('userToken')!;

      final response = await http
          .get(Uri.parse('$port$endpoint'), headers: {'token': token});

      if (response.statusCode == 200) {
        List alerts = jsonDecode(response.body);
        if (alerts.isNotEmpty) {
          return await getStockItems(alerts, token);
        }
      }
    } catch (e) {
      await isTokenExpired(e);
      throw Exception(e);
    }
    return [];
  }

  static Future<List<StockItem?>> getStockItems(
      List stockIDs, String token) async {
    try {
      String endpoint = '/org/stock/item';
      final res = await http.post(Uri.parse('$port$endpoint'),
          headers: {'token': token},
          body: jsonEncode({'stockItems': stockIDs}));

      if (res.statusCode == 200) {
        List<dynamic> resList = (jsonDecode(res.body) as List<dynamic>);
        if (resList.isNotEmpty) {
          return resList.map((json) => StockItem.fromJson(json)).toList();
        } else {
          return [];
        }
      }
    } catch (e) {
      await isTokenExpired(e);
      throw Exception(e);
    }
    return [];
  }
}
