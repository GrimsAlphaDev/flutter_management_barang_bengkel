import 'package:flutter/material.dart';
import 'package:management_barang_bengkel/controllers/belibarangscreen_provider.dart';
import 'package:management_barang_bengkel/controllers/jualbarangscreen_provider.dart';
import 'package:management_barang_bengkel/controllers/listbarangscreen_provider.dart';
import 'package:management_barang_bengkel/controllers/mainscreen_provider.dart';
import 'package:management_barang_bengkel/helper/db_helper.dart';
import 'package:management_barang_bengkel/views/mainscreen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MainScreenProvider()),
        ChangeNotifierProvider(
          create: (context) => ListBarangScreenProvider(DBHelper()),
        ),
        ChangeNotifierProvider(
            create: (context) => JualBarangScreenProvider(DBHelper())),
        ChangeNotifierProvider(create: (context) => BeliBarangScreenProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kencana Motor',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home: MainScreen(),
    );
  }
}
