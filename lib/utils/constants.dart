import 'package:frontend/services/auth_services.dart';
import 'package:frontend/widgets/notify.dart';
import 'package:get/get.dart';

double screenHeight = Get.context!.height;
double screenWidth = Get.context!.width;
// String port = 'http://10.0.2.2:9000';
String port = 'https://chain-stock-backend.onrender.com';

// sH and sW methods converts pixelHeight to Dynamic equivalent
double sH(double pixelHeight) {
  return screenHeight / (screenHeight / pixelHeight);
}

double sW(double pixelWidth) {
  return screenWidth / (screenWidth / pixelWidth);
}

Future<void> isTokenExpired(Object e) async {
  if (e.toString().contains('token is expired')) {
    AuthServices.appLogout();
    dangerMessage('Session expired. Please log in again.');
  }
}
