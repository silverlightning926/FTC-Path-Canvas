import 'package:flutter/material.dart';
import 'package:ftc_path_canvas/screens/welcome_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "FTC Path Canvas",
      home: const WelcomeScreen(),
      theme: ThemeData.dark().copyWith(
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 48.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
