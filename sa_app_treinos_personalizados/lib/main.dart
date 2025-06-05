import 'package:flutter/material.dart';
import 'package:sa_app_treinos_personalizados/views/home_screen.dart';
// Make sure this file exists and exports HomeScreen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Treinos',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
    );
  }
}
