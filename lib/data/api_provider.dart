import 'package:flutter/foundation.dart';

class ApiProvider {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8080';
    } else {
      // Android Emulator logic, can be expanded for iOS if needed
      return 'http://10.0.2.2:8080';
    }
  }
}
