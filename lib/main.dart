import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io';
import 'routes/app_routes.dart';
import 'database/database_helper.dart';
import 'screens/teste_screen.dart';
import 'screens/subestacoes_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  if (Platform.isWindows) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    print('✅ FFI inicializado');
  }
  
  try {
    await DatabaseHelper.instance.database;
    print('✅ Banco de dados OK');
  } catch (e) {
    print('❌ Erro: $e');
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Inspeções CEMIG',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      initialRoute: '/teste',
      routes: {
        '/teste': (context) => const TesteScreen(),
        '/subestacoes': (context) => const SubestacoesScreen(),
      },
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}