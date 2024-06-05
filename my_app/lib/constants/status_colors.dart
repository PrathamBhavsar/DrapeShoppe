import 'package:flutter/material.dart';

Color getCardColor(String status) {
  switch (status) {
    case 'New':
      return Colors.blueGrey.shade100;
    case 'Assigned':
      return Colors.lightGreenAccent.shade200;
    case 'Opened':
      return Colors.lightGreen.shade100;
    case 'Accepted':
      return Colors.pink.shade100;
    case 'Measured':
      return Colors.white24;
    case 'Installed':
      return Colors.redAccent.shade100;
    case 'Approved':
      return Colors.yellow.shade100;
    case 'Bill Submitted':
      return Colors.purple.shade100;
    default:
      return Colors.grey;
  }
}
