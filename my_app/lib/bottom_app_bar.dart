import 'package:flutter/material.dart';
import 'package:my_app/screens/SalesCompletedScreen.dart';
import 'package:my_app/screens/agent_billed_screen.dart';
import 'package:my_app/screens/agent_completed_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_app/screens/agent_home_screen.dart';
import 'package:my_app/screens/profile.dart';
import 'package:my_app/screens/sales_home_screen.dart';

import 'screens/sales_billed_screen.dart';

class BottomAppBarWidget extends StatefulWidget {
  const BottomAppBarWidget({super.key});

  @override
  State<BottomAppBarWidget> createState() => _BottomAppBarWidgetState();
}

class _BottomAppBarWidgetState extends State<BottomAppBarWidget> {
  int _index = 0;
  List<Widget> widgets = [CircularProgressIndicator(), CircularProgressIndicator()];
  String userType = 'Salesperson';

  @override
  void initState() {
    super.initState();
    _loadUserType();
  }

  Future<void> _loadUserType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userType = prefs.getString('userType') ?? 'Salesperson';
    setState(() {
      widgets = [
        userType == 'Salesperson' ? SalesHomeScreen() : AgentHomeScreen(),
        userType == 'Salesperson' ? SalesCompletedScreen() : AgentOpenedScreen(),
        userType == 'Salesperson' ? SalesBilledScreen() : AgentBilledScreen(),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    // Ensure widgets are initialized before use
    return Scaffold(
      bottomNavigationBar: SizedBox(
        height: 80,
        child: BottomNavigationBar(
          iconSize: 24,
          type: BottomNavigationBarType.fixed,
          elevation: 5,
          currentIndex: _index,
          onTap: _itemTapped,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Open'),
            BottomNavigationBarItem(icon: Icon(Icons.checklist_rtl), label: 'Completed'),
            BottomNavigationBarItem(icon: Icon(Icons.monetization_on_outlined), label: 'Billed'),
          ],
        ),
      ),
      body: widgets[_index],
    );
  }

  void _itemTapped(int index) {
    setState(() {
      _index = index;
    });
  }
}
