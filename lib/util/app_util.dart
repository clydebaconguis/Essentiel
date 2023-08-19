import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';

class AppUtil {
  int hexToColor(String hexString) {
    // Remove any leading # symbol
    if (hexString.startsWith('#')) {
      hexString = hexString.substring(1);
    }

    // Convert the hexadecimal color code to an integer
    int colorValue = int.parse(hexString, radix: 16);

    // If the hex string doesn't include an alpha value, add 0xFF (fully opaque) to the beginning
    if (hexString.length == 6) {
      colorValue = 0xFF000000 + colorValue;
    }
    // schoolvaluecolor = colorValue;

    // Create a Color object from the integer value
    return colorValue;
  }

  void changeStatusBarColor(schoolcolor) async {
    try {
      await FlutterStatusbarcolor.setStatusBarColor(Color(schoolcolor));
      if (useWhiteForeground(Color(schoolcolor))) {
        FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
      } else {
        FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("Failed to change status bar color on web: $e");
      }
    }
  }
}
