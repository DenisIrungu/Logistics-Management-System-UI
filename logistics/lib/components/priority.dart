import 'package:flutter/material.dart';

class PriorityCard extends StatelessWidget {
  final String title;
  final String description;

  const PriorityCard({required this.title, required this.description, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange,
        border: Border.all(color: Color(0xFF0F0156), width: 3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title: $title',
              style: const TextStyle(
                  color: Color(0xFF0F0156),
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text('Description: $description',
                style: const TextStyle(
                  color: Color(0xFF0F0156),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                )),
            const SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
                child: const Text('Attend'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
