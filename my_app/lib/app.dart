import 'package:flutter/material.dart';
import 'package:my_app/screens/home_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(


      home: const HomeScreen(),
    );
  }
}
