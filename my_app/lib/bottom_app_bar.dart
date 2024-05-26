import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_app/screens/agent_home_screen.dart';
import 'package:my_app/screens/profile.dart';
import 'package:my_app/screens/sales_home_screen.dart';

class BottomAppBarWidget extends StatefulWidget {
  const BottomAppBarWidget({super.key});

  @override
  State<BottomAppBarWidget> createState() => _BottomAppBarWidgetState();
}

class _BottomAppBarWidgetState extends State<BottomAppBarWidget> {
  int _index = 0;
  List<Widget> widgets = [CircularProgressIndicator(), CircularProgressIndicator()];
  String userType = 'Salesperson'; // Default value, should be updated

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
        ProfileScreen(),
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
            BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Bills'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
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
