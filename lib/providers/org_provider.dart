import 'package:flutter/material.dart';
import 'package:frontend/models/organization.dart';
import 'package:frontend/services/auth_services.dart';

class OrgProvider extends ChangeNotifier {
  Organization? organization;
  bool isLoading = false;
  String? error;

  Future<bool> validateOrg(String orgID) async {
    bool res = false;
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      organization = await AuthServices.validateOrgID(orgID);
      res = true;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return res;
  }

  void orgDispose() {
    organization = null;
    notifyListeners();
  }
}
