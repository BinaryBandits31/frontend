import 'dart:convert';
import 'package:frontend/models/raw_material.dart';
import 'package:frontend/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RawMaterialServices {
  static String endpoint = "/org/material";

  static Future<List<RawMaterial>> fetchRawMaterials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('userToken')!;

      final response = await http
          .get(Uri.parse('$port$endpoint'), headers: {'token': token});

      if (response.statusCode == 200) {
        return (jsonDecode(response.body) as List<dynamic>)
            .map((json) => RawMaterial.fromJson(json))
            .toList();
      } else {
        throw Exception(jsonDecode(response.body)['error']);
      }
    } catch (e) {
      await isTokenExpired(e);
      throw Exception(e);
    }
  }

  // static createNewUser(RawMaterial rawMaterial) {}

  static Future<bool> createNewUser(RawMaterial rawMaterial) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('userToken')!;

      final response = await http.post(Uri.parse('$port$endpoint'),
          headers: {'token': token}, body: jsonEncode(rawMaterial.toJson()));

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

  // static Future<bool> editProduct(Product product) async {
  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     String token = prefs.getString('userToken')!;

  //     final response = await http.put(
  //       Uri.parse('$port$endpoint/${product.id}'),
  //       headers: {'token': token},
  //       body: jsonEncode({'price': 44.99}),
  //     );

  //     if (response.statusCode == 200) {
  //       return true;
  //     } else {
  //       throw Exception(jsonDecode(response.body)['error']);
  //     }
  //   } catch (e) {
  //     await isTokenExpired(e);
  //     throw Exception(e);
  //   }
  // }

  // static Future<bool> deleteProduct(String productId) async {
  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     String token = prefs.getString('userToken')!;

  //     final response = await http.delete(
  //       Uri.parse('$port$endpoint/$productId'),
  //       headers: {'token': token},
  //     );

  //     if (response.statusCode == 200) {
  //       return true;
  //     } else {
  //       throw Exception(jsonDecode(response.body)['error']);
  //     }
  //   } catch (e) {
  //     await isTokenExpired(e);
  //     throw Exception(e);
  //   }
  // }
}
