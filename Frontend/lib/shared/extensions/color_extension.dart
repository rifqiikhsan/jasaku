import 'package:flutter/material.dart';

const Map<String, Color> _colorMap = {
  'red': Colors.red,
  'blue': Colors.blue,
  'green': Colors.green,
  'yellow': Colors.yellow,
  'purple': Colors.purple,
  'orange': Colors.orange,
  'pink': Colors.pink,
  'grey': Colors.grey,
  'gray': Colors.grey,
};

extension ColorExtension on String? {
  Color get toColor =>
      _colorMap[this?.toLowerCase()] ?? const Color(0xFFEEEEEE);
}
