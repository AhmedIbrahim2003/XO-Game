import 'package:flutter/material.dart';
import 'package:xo_game/HomePage_Screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF00061A),
        shadowColor: const Color(0xFF001456),
        splashColor: const Color(0xFF4169e8)
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePageScreen()
    );
  }
}
