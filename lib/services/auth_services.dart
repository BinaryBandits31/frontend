import 'package:frontend/models/organization.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';

import '../models/user.dart';
import '../providers/org_provider.dart';

class AuthServices {
  static String port = 'http://10.0.2.2:9000';

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
}
