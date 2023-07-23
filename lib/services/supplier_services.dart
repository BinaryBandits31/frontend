import 'dart:convert';
import 'package:frontend/models/supplier.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class SupplierServices {
  static String port = 'http://10.0.2.2:9000';
  static String endpoint = '/org/supplier/';

  static Future<List<Supplier>> fetchSuppliers() async {
    final String token =
        Provider.of<UserProvider>(Get.context!, listen: false).user!.token;

    try {
      final response = await http
          .get(Uri.parse('$port$endpoint'), headers: {'token': token});

      if (response.statusCode == 200) {
        return (jsonDecode(response.body) as List<dynamic>)
            .map((json) => Supplier.fromJson(json))
            .toList();
      } else {
        throw Exception(jsonDecode(response.body)['error']);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<bool> createSupplier(data) async {
    final String token =
        Provider.of<UserProvider>(Get.context!, listen: false).user!.token;

    final response = await http.post(Uri.parse('$port/org/supplier'),
        headers: {'token': token},
        body: jsonEncode(Supplier(
          name: data['name'],
          email: data['email'],
          phone: data['phone'],
          address: data['address'],
        ).toJson()));

    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception(jsonDecode(response.body)['error']);
    }
  }

  static void editSupplier(data) async {}
}
