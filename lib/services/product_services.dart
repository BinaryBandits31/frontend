import 'dart:convert';
import 'package:frontend/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/product.dart';

class ProductServices {
  static String endpoint = "/org/product";

  static Future<List<Product>> fetchProducts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('userToken')!;

      final response = await http
          .get(Uri.parse('$port$endpoint'), headers: {'token': token});

      if (response.statusCode == 200) {
        return (jsonDecode(response.body) as List<dynamic>)
            .map((json) => Product.fromJson(json))
            .toList();
      } else {
        throw Exception(jsonDecode(response.body)['error']);
      }
    } catch (e) {
      await isTokenExpired(e);
      throw Exception(e);
    }
  }

  static Future<bool> createProduct(Product product) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('userToken')!;

      final response = await http.post(Uri.parse('$port/org/product'),
          headers: {'token': token}, body: jsonEncode(product.toJson()));

      if (response.statusCode == 201) {
        return true;
      } else {
        throw Exception(jsonDecode(response.body)['error']);
      }
    } catch (e) {
      await isTokenExpired(e);
      throw Exception(e);
    }
  }

  static Future<bool> editProduct(Product product) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('userToken')!;

      final response = await http.put(
        Uri.parse('$port$endpoint/${product.id}'),
        headers: {'token': token},
        body: jsonEncode({'price': 44.99}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(jsonDecode(response.body)['error']);
      }
    } catch (e) {
      await isTokenExpired(e);
      throw Exception(e);
    }
  }

  static Future<bool> deleteProduct(String productId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('userToken')!;

      final response = await http.delete(
        Uri.parse('$port$endpoint/$productId'),
        headers: {'token': token},
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(jsonDecode(response.body)['error']);
      }
    } catch (e) {
      await isTokenExpired(e);
      throw Exception(e);
    }
  }
}
