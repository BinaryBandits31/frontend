import 'package:flutter/material.dart';
import 'package:frontend/models/organization.dart';
import 'package:frontend/services/auth_services.dart';

class OrgProvider extends ChangeNotifier {
  Organization? organization;
  bool isLoading = false;
  String? error;

  Future<void> fetchOrganization(String orgID) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      organization = await AuthServices.validateOrgID(orgID);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void orgLogOut() {
    organization = null;
    notifyListeners();
  }
}
