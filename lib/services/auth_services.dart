import 'package:flutter/material.dart';
import 'package:frontend/models/organization.dart';
import 'package:frontend/providers/app_provider.dart';
import 'package:frontend/providers/branch_provider.dart';
import 'package:frontend/providers/stock_purchase_provider.dart';
import 'package:frontend/providers/stock_transfer_provider.dart';
import 'package:frontend/providers/supplier_provider.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/utils/constants.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/user.dart';
import '../pages/auth/user_login.dart';
import '../providers/org_provider.dart';

class AuthServices {
  static Future<bool> signUp(dynamic data) async {
    final response = await http.post(
      Uri.parse('$port/user/signup'),
      body: jsonEncode({
        'owner_name': data['fullName'],
        'password': data['password'],
        'org_Name': data['orgName'],
        'org_Phone': data['orgPhone'],
        'org_Id': data['orgID'],
        'org_Email': data['orgEmail'],
        'branch_Type': 'RETAIL',
      }),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception(jsonDecode(response.body)['error']);
    }
  }

  static Future<User> userLogin(dynamic data) async {
    final orgID =
        Provider.of<OrgProvider>(Get.context!, listen: false).organization!.id;

    final response = await http.post(
      Uri.parse('$port/user/login'),
      body: jsonEncode({
        'username': data['username'],
        'org_Id': orgID,
        'password': data['password'],
      }),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(jsonDecode(response.body)['error']);
    }
  }

  static Future<Organization> validateOrgID(String orgID) async {
    final response =
        await http.get(Uri.parse('$port/user/validate/org/$orgID'));

    if (response.statusCode == 200) {
      return Organization.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(jsonDecode(response.body)['error']);
    }
  }

  static Future<User> validateUserToken(String token) async {
    String endpoint = '/user/validate/token/';
    final response =
        await http.get(Uri.parse('$port$endpoint'), headers: {'token': token});

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(jsonDecode(response.body)["error"]);
    }
  }

  static Future<bool> updateUserPassword(dynamic data) async {
    String endpoint = '/org/employee/change_password';
    try {
      final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('userToken')!;
      final res = await http.put(Uri.parse('$port$endpoint'),
          headers: {'token': token}, body: jsonEncode(data));

      if (res.statusCode == 200) {
        return true;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  static Future<bool> createNewUser(dynamic data) async {
    String endpoint = '/org/employee';
    try {
      final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('userToken')!;
      final res = await http.post(Uri.parse('$port$endpoint'),
          headers: {'token': token}, body: jsonEncode(data));

      if (res.statusCode == 201) {
        return true;
      }
    } catch (e) {
      Provider.of<UserProvider>(Get.context!, listen: false)
          .setCreateUserError(e.toString());
      debugPrint(e.toString());
    }
    return false;
  }

  static Future<void> appLogout() async {
    // Handle logout action
    Provider.of<AppProvider>(Get.context!, listen: false).appDispose();

    Provider.of<UserProvider>(Get.context!, listen: false).userDispose();

    Provider.of<BranchProvider>(Get.context!, listen: false).branchDispose();

    Provider.of<SupplierProvider>(Get.context!, listen: false)
        .supplierDispose();

    Provider.of<StockTransferProvider>(Get.context!, listen: false).disposeST();

    Provider.of<StockPurchaseProvider>(Get.context!, listen: false).disposeSP();

    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove('userToken');
    Get.off(() => const UserLogin());
  }

  static Future<List<User>?> fetchFellowUsers() async {
    String endpoint = '/org/branch/employee/_';
    try {
      final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('userToken')!;
      final res = await http
          .get(Uri.parse('$port$endpoint'), headers: {'token': token});

      if (res.statusCode == 200) {
        if (jsonDecode(res.body) != null) {
          return (jsonDecode(res.body) as List<dynamic>)
              .map((e) => User.fromJson(e))
              .toList();
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }
}
