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
}
