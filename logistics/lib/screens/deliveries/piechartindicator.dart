import 'package:flutter/material.dart';
import 'package:logistcs/components/piedata.dart';

class PieChartIndicator extends StatelessWidget {
  const PieChartIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: PieData.data
          .map((data) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: buildIndicator(color: data.color, text: data.name),
              ))
          .toList(),
    );
  }

  /// ✅ Corrected buildIndicator method
  Widget buildIndicator({
    required Color color,
    required String text,
    bool isSquare = false,
    double size = 16,
  }) {
    return Row(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0F0156)),
        ),
      ],
    );
  }
}
