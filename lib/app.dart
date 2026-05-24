import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

class MatrixMotivationApp extends StatelessWidget {
  const MatrixMotivationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Matrix Motivation',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF00FF00),
        scaffoldBackgroundColor: Colors.black,
        fontFamily: 'monospace',
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00FF00),
          secondary: Color(0xFF00FF00),
          surface: Colors.black,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
