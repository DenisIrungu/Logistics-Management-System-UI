import 'package:flutter/material.dart';

class Data {
  final String name;
  final Color color;
  final double percent;

  const Data({required this.color, required this.name, required this.percent});
}

class PieData {
  static List<Data> data = [
    Data(color: Color(0xFFFF9500), name: 'On-Time', percent: 45),
    Data(color: Color(0xFF0F0156), name: 'Delivered', percent: 50),
    Data(color: Color(0xFFDADADA), name: 'Failed', percent: 5)
  ];
}
