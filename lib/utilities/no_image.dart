import 'dart:typed_data';

import 'package:flutter/services.dart';

class NoImage {
  static Future<Uint8List> getImage() async {
    final byteData = await rootBundle.load("assets/images/no-image.png");
    final bytes = byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
    return bytes;
  }
}
