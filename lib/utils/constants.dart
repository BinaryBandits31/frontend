import 'package:get/get.dart';

double screenHeight = Get.context!.height;
double screenWidth = Get.context!.width;

// sH and sW methods converts pixelHeight to Dynamic equivalent
double sH(double pixelHeight) {
  return screenHeight / (screenHeight / pixelHeight);
}

double sW(double pixelWidth) {
  return screenWidth / (screenWidth / pixelWidth);
}
