import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_4/screens/expense_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if(!kIsWeb) {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        
        colorScheme: .fromSeed(seedColor: Colors.blueAccent),
      ),
      home: ExpenseScreen(),
    );
  }
}


