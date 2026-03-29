import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io';

class DatabaseConfig {
  static void initialize() {
    if (Platform.isWindows) {
      // Inicializar o FFI para Windows
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
    // Para outras plataformas, usa a implementação padrão
  }
}