import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;

class ApiConfig {
  static String get baseUrl {
    // Web (Chrome): el navegador llega directo a localhost.
    if (kIsWeb) return 'http://localhost:8000';

    // Emulador Android: 10.0.2.2 es el alias del localhost de tu PC.
    if (Platform.isAndroid) return 'http://10.0.2.2:8000';

    // Otros (iOS sim, escritorio): localhost.
    return 'http://localhost:8000';
  }
}