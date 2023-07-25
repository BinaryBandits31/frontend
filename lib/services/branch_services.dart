import 'dart:convert';

import 'package:frontend/providers/org_provider.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/branch.dart';

class BranchServices {
  static String port = "http://10.0.2.2:9000";
  static String endpoint = "/org/branch/";

  static Future<List<Branch>> fetchBranches() async {
    final String orgID =
        Provider.of<OrgProvider>(Get.context!, listen: false).organization!.id;

    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('userToken')!;

    try {
      final response = await http
          .get(Uri.parse('$port$endpoint$orgID'), headers: {'token': token});

      if (response.statusCode == 200) {
        return (jsonDecode(response.body) as List<dynamic>)
            .map((json) => Branch.fromJson(json))
            .toList();
      } else {
        throw Exception(jsonDecode(response.body)['error']);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<bool> createBrach(data) async {
    final String orgID =
        Provider.of<OrgProvider>(Get.context!, listen: false).organization!.id;

    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('userToken')!;
    String newEndpoint = endpoint.substring(0, endpoint.length - 1);

    final response = await http.post(Uri.parse('$port$newEndpoint'),
        headers: {'token': token},
        body: jsonEncode({
          'name': data['name'],
          'branch_Type': data['type'],
          'org_Id': orgID,
        }));

    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception(jsonDecode(response.body)['error']);
    }
  }

  static Future<bool> editBranch(data) async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('userToken')!;

    final response =
        await http.put(Uri.parse('$port$endpoint${data["branchID"]}'),
            headers: {'token': token},
            body: jsonEncode({
              'name': data['name'],
              'branch_Type': data['type'],
            }));

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(jsonDecode(response.body)['error']);
    }
  }
}
