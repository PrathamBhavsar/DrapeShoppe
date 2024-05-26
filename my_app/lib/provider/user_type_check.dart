import 'package:flutter/material.dart';

class UserTypeProvider with ChangeNotifier {
  String _userType = 'Salesperson';

  String get userType => _userType;

  void setUserType(String userType) {
    _userType = userType;
    notifyListeners();
  }
}
