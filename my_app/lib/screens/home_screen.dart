import 'package:flutter/material.dart';
import 'package:my_app/bottom_app_bar.dart';


class HomeScreen extends StatelessWidget {

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ScaffoldMessenger(
      child: Scaffold(
        bottomNavigationBar: BottomAppBarWidget(),
      ),
    );
  }
}
