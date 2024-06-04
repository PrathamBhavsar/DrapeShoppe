import 'package:flutter/material.dart';

Color getCardColor(String status) {
  switch (status) {
    case 'Open':
      return Colors.blueGrey.shade100;
    case 'Accepted':
      return Colors.lightGreenAccent.shade200;
    case 'Submitted':
      return Colors.lightGreen.shade100;
    case 'Completed':
      return Colors.pink.shade100;
    case 'Unbilled':
      return Colors.white24;
    case 'Billed':
      return Colors.lightGreen.shade100;
    default:
      return Colors.grey;
  }
}