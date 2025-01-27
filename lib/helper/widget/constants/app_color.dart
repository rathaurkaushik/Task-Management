

import 'dart:ui';

import 'package:flutter/material.dart';

Color getPriorityColor(String priority) {
  switch (priority) {
    case 'High':
      return Colors.red;
    case 'Normal':
      return Colors.orange;
    case 'Low':
      return Colors.green;
    default:
      return Colors.black;
  }
}